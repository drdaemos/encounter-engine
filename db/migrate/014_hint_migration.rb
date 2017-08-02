# -*- encoding : utf-8 -*-
class HintMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :hints do |t|
      t.integer :level_id
      t.string :text
      t.integer :delay
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :hints
  end
end
