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
