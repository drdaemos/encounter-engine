# -*- encoding : utf-8 -*-
class Invitation < ApplicationRecord
  belongs_to :to_team, :class_name => "Team"
  belongs_to :for_user, :class_name => "User"

  scope :for, ->(user) { where(for_user_id: user.id) }

  attr_accessor :recepient_nickname

  validates_presence_of :for_user,
    :message => "Пользователя с таким именем не существует"

  validates_uniqueness_of :for_user_id,
    :scope => [:to_team_id],
    :message => "Вы уже высылали этому пользователю приглашение и он ещё не ответил"

  validate :recepient_is_not_member_of_any_team

  scope :for_user, ->(user) { where(for_user_id: user.id) }
  scope :to_team, ->(team) { where(to_team_id: team.id) }

  protected

  def recepient_is_not_member_of_any_team
    errors.add(:base, "Пользователь уже является членом одной из команд") if for_user and for_user.member_of_any_team?
  end
end
