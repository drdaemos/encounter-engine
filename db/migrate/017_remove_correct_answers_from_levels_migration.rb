# -*- encoding : utf-8 -*-
class RemoveCorrectAnswersFromLevelsMigration < ActiveRecord::Migration[5.0]
	def self.up
		remove_column :levels, :correct_answers
	end

	def self.down
		add_column :levels, :correct_answers, :string
	end
end
