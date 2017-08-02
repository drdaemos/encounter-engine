# -*- encoding : utf-8 -*-
class MaxTeamNumberMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :games, :max_team_number, :integer
    add_column :games, :requested_teams_number, :integer, {:default => 0}
  end

  def self.down
    remove_column :games, :max_team_number
    remove_column :games, :requested_teams_number
  end
end
