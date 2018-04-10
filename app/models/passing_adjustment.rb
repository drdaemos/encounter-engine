class PassingAdjustment < ApplicationRecord
  belongs_to :game_passing

  scope :of_game_passing, ->(game_passing) { where(game_passing_id: game_passing) }

  def type
    if self.adjustment.nil?
      :penalty
    else
      self.adjustment > 0 ? :bonus : :penalty
    end
  end
end
