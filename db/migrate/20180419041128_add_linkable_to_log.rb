class AddLinkableToLog < ActiveRecord::Migration[5.0]
  def change
    add_reference :logs, :linkable, polymorphic: true, index: true
  end
end
