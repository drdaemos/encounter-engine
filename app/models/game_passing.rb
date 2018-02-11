class GamePassing < ApplicationRecord
  serialize :answered_questions
  serialize :opened_spoilers

  belongs_to :team
  belongs_to :game
  belongs_to :current_level, :class_name => "Level"
  has_many :level_results, :inverse_of => :game_passing

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

  def check_spoiler!(code)
    code.strip!

    if correct_spoiler_code?(code)
      spoiler = current_level.find_hint_by_code(code)
      open_spoiler!(spoiler)
      true
    else
      false
    end
  end

  def check_answer!(answer)
    answer.strip!

    if correct_answer?(answer)
    	answered_question = current_level.find_question_by_answer(answer)
    	pass_question!(answered_question)
    	pass_level! if all_questions_answered?
    	true
   	else
    	false
    end
  end

  def pass_question!(question)
		answered_questions << question
		save!
  end

  def open_spoiler!(hint)
    opened_spoilers << hint
    save!
  end

  def pass_level!
    switch_to_next_level!
  end

  def fail_level!
    switch_to_next_level!
  end

  def finished?
    !! finished_at
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

  def time_at_level
    difference = Time.now - self.current_level_entered_at
    hours, minutes, seconds = seconds_fraction_to_time(difference)
    "%02d:%02d:%02d" % [hours, minutes, seconds]
  end

  def closed_spoilers
    current_level.hints - opened_spoilers
  end

  def unanswered_questions
		current_level.questions - answered_questions
	end

  def all_questions_answered?
    (current_level.questions - self.answered_questions).empty?
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

  def save_level_result
    entity = LevelResult.new({
        :level => self.current_level,
        :answered_questions => self.answered_questions,
        :entered_at => self.current_level_entered_at,
        :adjustment => 0,
        :game_passing => self
    })

    entity.save!
    self.level_results << entity
  end

  def switch_to_next_level!
    save_level_result

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

  # TODO: keep SRP, extract this to a separate helper
  def seconds_fraction_to_time(seconds)
    hours = minutes = 0
    if seconds >=  60 then
      minutes = (seconds / 60).to_i
      seconds = (seconds % 60 ).to_i

      if minutes >= 60 then
        hours = (minutes / 60).to_i
        minutes = (minutes % 60).to_i
      end
    end
    [hours, minutes, seconds]
  end

end
