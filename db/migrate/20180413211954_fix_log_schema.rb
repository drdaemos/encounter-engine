class FixLogSchema < ActiveRecord::Migration[5.0]
  def change
    drop_table :logs
    create_table :logs do |t|
      t.integer :game_passing_id
      t.integer :level_id
      t.string :answer
      t.boolean :is_correct
      t.timestamps
    end

    add_foreign_key :logs, :game_passings, on_delete: :cascade
    add_foreign_key :logs, :levels, on_delete: :cascade
  end
end