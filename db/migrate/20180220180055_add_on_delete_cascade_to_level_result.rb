class AddOnDeleteCascadeToLevelResult < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :level_results, :game_passings, on_delete: :cascade
  end
end
