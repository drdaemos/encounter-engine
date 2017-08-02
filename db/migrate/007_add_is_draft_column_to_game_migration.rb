# -*- encoding : utf-8 -*-
class AddIsDraftColumnToGameMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :games, :is_draft, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :games, :is_draft
  end
end
