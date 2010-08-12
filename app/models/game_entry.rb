class GameEntry < ActiveRecord::Base
  belongs_to :game, :class_name => "Game"

  named_scope :of_game, lambda { |game| { :conditions => { :game_id => game.id } } }
  named_scope :with_status, lambda { |status| { :conditions => { :status  => status } } }

  validates_presence_of :game,
    :message => "Вы не выбрали игру"

  validates_presence_of :team_id,
    :message => "Вы не указали команду"

end