class Question < ApplicationRecord
  belongs_to :level
  has_many :answers
  has_many :logs, as: :linkable

  scope :of_level, ->(level) { where(level_id: level) }
  scope :bonus, ->() { where(is_counted_in_level: false) }
  scope :required, ->() { where(is_counted_in_level: true) }

  def correct_answer=(answer)
    self.answers.build(:value => answer)
  end

  def correct_answer
    self.answers.empty? ?
      nil :
      self.answers.first.value
  end

  def adjustment_time
    self.penalty_time.to_i.abs
  end

  def has_adjustment
    if self.penalty_time.nil?
      false
    else
      self.penalty_time.to_i.abs > 0 ? true : false
    end
  end

  def adjustment_time=(value)
  end

  def has_adjustment=(value)
  end

  def type=(value)
  end

  def type
    if self.penalty_time.nil?
      :penalty
    else
      self.penalty_time > 0 ? :penalty : :bonus
    end
  end

  def matches_any_answer?(answer_value)
    self.answers.any? {|answer| answer.value.mb_chars.upcase.to_s == answer_value.mb_chars.upcase.to_s}
  end
end
