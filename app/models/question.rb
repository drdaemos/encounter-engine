class Question < ApplicationRecord
  belongs_to :level
  has_many :answers

  def correct_answer=(answer)
    self.answers.build(:value => answer)
  end

  def correct_answer
    self.answers.empty? ?
      nil :
      self.answers.first.value
  end

  def matches_any_answer(answer_value)
    self.answers.any? {|answer| UnicodeUtils.upcase(answer.value.to_s) == UnicodeUtils.upcase(answer_value.to_s)}
  end
end
