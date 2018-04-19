# -*- encoding : utf-8 -*-
class Log < ApplicationRecord
  belongs_to :game_passing
  belongs_to :level
  belongs_to :linkable, optional: true, polymorphic: true

  scope :of_game, ->(game) { joins(:game_passing).where(game_passings: {game_id: game}) }
  scope :of_level, ->(level) { where(level_id: level) }
  scope :of_game_passing, ->(game_passing) { where(game_passing_id: game_passing) }

  def self.of (game_passing, level)
    logs = self.of_game_passing(game_passing).of_level(level).to_a.select do |log|
      !log.linkable.nil? && log.linkable.is_a?(Question)
    end
    logs.map { |log| log.answer }
  end
end
