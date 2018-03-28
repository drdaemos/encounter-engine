class PassingAdjustment < ApplicationRecord
  belongs_to :game_passing

  scope :of_game_passing, ->(game_passing) { where(game_passing_id: game_passing) }

  def self.clean_time(game_passing)
    sum = self.of_game_passing(game_passing).to_a.reduce(0.0) do |sum, result|
      sum += (result.created_at - result.entered_at)
      sum
    end

    self.human_diff(sum)
  end

  def self.adjusted_time(game_passing)
    sum = self.of_game_passing(game_passing).to_a.reduce(0.0) do |sum, result|
      sum += (result.created_at - result.entered_at - result.adjustment)
      sum
    end

    self.human_diff(sum)
  end

  def self.adjustment_time(game_passing)
    sum = self.of_game_passing(game_passing).to_a.reduce(0.0) do |sum, result|
      sum += (result.adjustment)
      sum
    end

    self.human_diff(sum)
  end

  def self.human_diff(diff)
    sign = ""
    if diff < 0
      sign = "-"
    end

    sign + Time.at(diff.abs).utc.strftime("%T")
  end

  def level_time
    LevelResult.human_diff(created_at - entered_at)
  end
end
