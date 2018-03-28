class AddPublishedToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :is_published, :boolean, :null => false, :default => false
  end
end
