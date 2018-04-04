class AddExtraLevelSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :levels, :is_used_in_stats, :boolean, :null => false, :default => true
    add_column :levels, :is_all_sectors_required, :boolean, :null => false, :default => true
    add_column :levels, :count_of_sectors_to_pass, :integer
    add_column :levels, :penalty_time_fail, :integer
    add_column :questions, :is_counted_in_level, :boolean, :null => false, :default => true
    add_column :questions, :penalty_time, :integer
  end
end
