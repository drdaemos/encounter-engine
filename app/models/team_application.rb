# -*- encoding : utf-8 -*-
class TeamApplication < ApplicationRecord
  belongs_to :team, :class_name => "Team"
  belongs_to :user, :class_name => "User"

  scope :of_user, ->(user) { where(user_id: user.id) }
  scope :for_team, ->(user) { where(team_id: user.id) }

  validates_presence_of :user,
    :message => "Пользователя с таким именем не существует"

  validates_presence_of :team,
    :message => "Команды с таким названием не существует"

  validates_uniqueness_of :team_id,
    :scope => [:user_id],
    :message => "Вы уже высылали запрос на вступление в эту команду"

  def self.exists?(some_user, some_team)
    !self.of_user(some_user).for_team(some_team).empty?
  end

  protected
end
