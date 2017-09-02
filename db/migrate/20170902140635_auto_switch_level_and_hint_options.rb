class AutoSwitchLevelAndHintOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :levels, :time_limit, :integer
    add_column :hints, :penalty_time, :integer
    add_column :hints, :access_code, :string
    add_column :logs, :answer_type, :string
  end
end
