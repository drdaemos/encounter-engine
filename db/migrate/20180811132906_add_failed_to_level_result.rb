class AddFailedToLevelResult < ActiveRecord::Migration[5.0]
  def change
    add_column :level_results, :is_failed, :boolean
  end
end
