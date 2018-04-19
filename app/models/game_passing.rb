require_dependency "question"
require_dependency "hint"

class GamePassing < ApplicationRecord
  serialize :answered_questions
  serialize :opened_spoilers

  belongs_to :team
  belongs_to :game
  belongs_to :current_level, :class_name => "Level"
  has_many :level_results, :inverse_of => :game_passing
  has_many :passing_adjustments, :inverse_of => :game_passing

  scope :of_game, ->(game) { where(game_id: game) }
  scope :of_team, ->(team) { where(team_id: team) }
  scope :ended_by_author, -> { where(status: 'ended').order('current_level_id DESC') }
  scope :exited, -> { where(status: 'exited').order('finished_at DESC') }
  scope :finished, -> { where.not(finished_at: nil).order('finished_at ASC') }
  scope :finished_before, ->(time) { where('finished_at < ?', time) }

  before_update :update_current_level_data, if: :current_level_id_changed?

  before_save { self.answered_questions ||= [] }
  before_save { self.opened_spoilers ||= [] }

  def self.of(team, game)
    self.of_team(team).of_game(game).first
  end

  def pass_question!(question, answer)
    unless question.penalty_time.nil?
      text = question.penalty_time > 0 ? "Штрафной код" + answer : "Бонусный код" + answer
      add_adjustment!(-question.penalty_time, text)
    end

		answered_questions << question
		save!
  end

  def open_spoiler!(hint)
    unless hint.penalty_time.nil?
      text = hint.access_code || ("через " + hint.delay_in_minutes + " минут")
      add_adjustment!(-hint.penalty_time, "Штрафная подсказка " + text)
    end

    opened_spoilers << hint
    save!
  end

  def pass_level!
    switch_to_next_level!
  end

  def fail_level!
    switch_to_next_level! (true)
  end

  def finished?
    !! finished_at || exited?
  end

  def hints_to_show
    current_level.hints.select { |hint| hint.ready_to_show?(current_level_entered_at) or opened_spoilers.any? {|h| h.access_code == hint.access_code } }
  end

  def upcoming_hints
    current_level.hints.select { |hint| !hint.ready_to_show?(current_level_entered_at) and !hint.is_spoiler? }
  end

  def correct_answer?(answer)
    unanswered_questions.any? { |question| question.matches_any_answer?(answer) }
  end

  def correct_spoiler_code?(code)
    closed_spoilers.any? { |hint| hint.is_opened_by?(code) }
  end

  def closed_spoilers
    current_level.hints - opened_spoilers
  end

  def unanswered_questions
		current_level.questions - answered_questions
  end

  def answered_questions_of_level
    answered_questions.to_a.select { |question| question.level == current_level }
  end

  def all_questions_answered?
    (current_level.questions - self.answered_questions - current_level.bonus_questions).empty?
  end

  def questions_answered?
    if current_level.is_all_sectors_required?
      all_questions_answered?
    else
      (self.answered_questions - current_level.bonus_questions).size >= current_level.count_of_sectors_to_pass
    end
  end

  def add_adjustment! (amount, reason)
    entity = PassingAdjustment.new({
         :reason => reason,
         :adjustment => amount,
         :game_passing => self
     })

    entity.save!
    self.passing_adjustments << entity
  end

  def exit!
    self.finished_at = Time.now
    self.status = "exited"
    self.save!
  end

  def exited?
    self.status == "exited"
  end

  def end!
    unless self.exited?
      self.status = "ended"
      self.save!
    end
  end

protected

  def save_level_result (is_failed)
    entity = LevelResult.new({
        :level => self.current_level,
        :answered_questions => self.answered_questions,
        :entered_at => self.current_level_entered_at,
        :time_limit => self.current_level.time_limit,
        :adjustment => 0,
        :game_passing => self
    })

    if is_failed && !self.current_level.penalty_time_fail.nil?
      entity.adjustment = -self.current_level.penalty_time_fail
    end

    entity.save!
    self.level_results << entity
  end

  def switch_to_next_level! (is_failed = false)
    save_level_result (is_failed)

    if last_level?
      set_finish_time
    end

    self.current_level = self.current_level.next
    self.save!
  end

  def last_level?
    self.current_level.next.nil?
  end

  def update_current_level_data
    reset_answered_questions
    reset_spoilers
    self.current_level_entered_at = Time.now
  end

  def set_finish_time
  	self.finished_at = Time.now
  end

  def reset_answered_questions
    self.answered_questions.clear
  end

  def reset_spoilers
    self.opened_spoilers.clear
  end

end
