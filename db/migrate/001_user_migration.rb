# -*- encoding : utf-8 -*-
class UserMigration < ActiveRecord::Migration[5.0]
  def up
    create_table :users do |t|
      t.string :name
      t.timestamps null: false
    end
  end

  def down
    drop_table :users
  end
end
