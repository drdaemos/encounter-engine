class LevelResult < ApplicationRecord
  serialize :answered_questions

  belongs_to :game_passing
  belongs_to :level
end
