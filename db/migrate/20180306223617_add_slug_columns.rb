class AddSlugColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :slug, :string
    add_index :teams, :slug, :unique => true

    add_column :users, :slug, :string
    add_index :users, :slug, :unique => true
  end
end
