class AddExtraFieldsToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :notes, :text
    add_column :games, :accessories, :text
    add_column :games, :finished_at, :datetime
  end
end
