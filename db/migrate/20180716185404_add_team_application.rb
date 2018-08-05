class AddTeamApplication < ActiveRecord::Migration[5.0]
  def change
    create_table :team_applications do |t|
      t.integer :team_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
