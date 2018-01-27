class ChangeTypeToFieldType < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :field_type, :string, :default => "text"
    remove_column :settings, :type
  end
end
