class AddLabelToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :label, :string
  end
end
