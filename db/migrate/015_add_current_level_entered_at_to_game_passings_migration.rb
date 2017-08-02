# -*- encoding : utf-8 -*-
class AddCurrentLevelEnteredAtToGamePassingsMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :game_passings, :current_level_entered_at, :datetime
  end

  def self.down
    remove_column :game_passings, :current_level_entered_at
  end
end
