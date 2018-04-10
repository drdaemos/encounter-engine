# coding: utf-8

class Level < ApplicationRecord
  acts_as_list :scope => :game

  belongs_to :game
  has_many :questions
  has_many :answers
  has_many :hints, -> { order('delay ASC') }

  validates_presence_of :name,
    :message => "Вы не ввели название задания"

  validates_presence_of :text,
    :message => "Вы не ввели текст задания"

  validates_presence_of :game

  scope :of_game, ->(game) { where(game_id: game) }

  def next
    lower_item
  end

  def penalty_time_fail_in_minutes
    self.penalty_time_fail.nil? ? nil : self.penalty_time_fail / 60
  end

  def penalty_time_fail_in_minutes=(value)
    self.penalty_time_fail = value.to_i * 60
  end

  def time_limit_in_minutes
    self.time_limit.nil? ? nil : self.time_limit / 60
  end

  def time_limit_in_minutes=(value)
    self.time_limit = value.to_i * 60
  end

  def correct_answer=(answer)
    self.questions.build(:correct_answer => answer)
  end

  def correct_answer
    self.questions.empty? ?
      nil :
      self.questions.first.answers.first.value
  end

  def multi_question?
    self.questions.many?
  end

  def question_count
    if !self.is_all_sectors_required? && !self.count_of_sectors_to_pass.nil?
      self.count_of_sectors_to_pass
    end

    self.required_questions.count
  end

  def bonus_questions
    Question.of_level(self.id).bonus
  end

  def required_questions
    Question.of_level(self.id).required
  end

  def find_question_by_answer(answer_value)
    self.questions.detect do |question|
      question.answers.any? { |answer| answer.value.mb_chars.upcase.to_s == answer_value.mb_chars.upcase.to_s}
    end
  end

  def find_hint_by_code(code)
    self.hints.detect do |hint|
      hint.is_opened_by?(code)
    end
  end
end
