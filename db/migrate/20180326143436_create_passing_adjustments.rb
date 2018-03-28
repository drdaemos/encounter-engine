class CreatePassingAdjustments < ActiveRecord::Migration[5.0]
  def change
    create_table :passing_adjustments do |t|
      t.integer :game_passing_id
      t.integer :adjustment
      t.string :reason
      t.timestamps
    end

    add_foreign_key :passing_adjustments, :game_passings, on_delete: :cascade
  end
end
