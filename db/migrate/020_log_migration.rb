# -*- encoding : utf-8 -*-
class LogMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :logs do |t|
      t.integer :game_id
      t.string :team
      t.string :level
      t.string :answer
      t.timestamp :time
    end
  end

  def self.down
    drop_table :logs
  end
end
