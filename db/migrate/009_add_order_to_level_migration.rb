# -*- encoding : utf-8 -*-
class AddOrderToLevelMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :levels, :order, :integer
  end

  def self.down
    remove_column :levels, :order
  end
end
