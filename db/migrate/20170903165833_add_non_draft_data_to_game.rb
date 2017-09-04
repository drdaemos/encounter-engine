class AddNonDraftDataToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :preserved_data, :text
    remove_column :games, :test_date
  end
end
