# -*- encoding : utf-8 -*-
class TestGameMigration < ActiveRecord::Migration[5.0]
 def self.up
  add_column :games, :is_testing, :boolean, :null => false, :default => false
  add_column :games, :test_date, :datetime
 end

 def self.down
  remove_column :games, :is_testing
  remove_column :games, :test_date
 end
end
