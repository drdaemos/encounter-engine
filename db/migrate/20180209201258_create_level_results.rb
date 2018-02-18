class CreateLevelResults < ActiveRecord::Migration[5.0]
  def change
    create_table :level_results do |t|
      t.text :answered_questions
      t.integer :game_passing_id
      t.integer :level_id
      t.integer :adjustment
      t.datetime :entered_at
      t.timestamps
    end
  end
end
