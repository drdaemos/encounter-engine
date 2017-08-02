# -*- encoding : utf-8 -*-
class RenameOrderToPositionMigration < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :levels, :order, :position
  end

  def self.down
    rename_column :levels, :position, :order
  end
end
