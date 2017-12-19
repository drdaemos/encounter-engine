class AddAttachmentFields < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar, :string
    add_column :games, :poster, :string
  end
end
