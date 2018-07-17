class AddCascadeToUser < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :teams, :users, column: :captain_id, on_delete: :nullify
    add_foreign_key :users, :teams, column: :team_id, on_delete: :nullify
  end
end
