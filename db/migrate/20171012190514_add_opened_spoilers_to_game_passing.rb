class AddOpenedSpoilersToGamePassing < ActiveRecord::Migration[5.0]
  def change
    add_column :game_passings, :opened_spoilers, :text
  end
end
