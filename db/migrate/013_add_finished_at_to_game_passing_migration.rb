# -*- encoding : utf-8 -*-
class AddFinishedAtToGamePassingMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :game_passings, :finished_at, :datetime
  end

  def self.down
    remove_column :game_passings, :finished_at
  end
end
