require_relative "question"

class LevelResult < ApplicationRecord
  serialize :answered_questions

  belongs_to :game_passing
  belongs_to :level

  scope :of_game_passing, ->(game_passing) { where(game_passing_id: game_passing) }
  scope :of_level, ->(level) { where(level_id: level) }
  scope :counted_in_stats, ->(value) { joins(:level).where(levels: {is_used_in_stats: value}) }

  def self.of(game_passing, level)
    self.of_game_passing(game_passing).of_level(level).first
  end

  def level_time
    if !self.time_limit.nil? && (is_failed? || self.time_limit < (created_at - entered_at))
      self.time_limit
    else
      (created_at - entered_at)
    end
  end
end
