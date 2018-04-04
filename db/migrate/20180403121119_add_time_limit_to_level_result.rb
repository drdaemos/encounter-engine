class AddTimeLimitToLevelResult < ActiveRecord::Migration[5.0]
  def change
    add_column :level_results, :time_limit, :integer
  end
end
