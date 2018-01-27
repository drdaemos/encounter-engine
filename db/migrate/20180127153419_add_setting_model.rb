class AddSettingModel < ActiveRecord::Migration[5.0]
  def up
    create_table :settings do |t|
      t.string :key
      t.text :value
    end
  end

  def down
    drop_table :settings
  end
end
