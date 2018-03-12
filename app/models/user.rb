# -*- encoding : utf-8 -*-
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :nickname, use: :slugged

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  bitmask :access_level, :as => [:player, :organizer, :admin]
  belongs_to :team
  has_many :created_games, :class_name => "Game", :foreign_key => "author_id"
  mount_uploader :avatar, AvatarUploader

  validates_presence_of :email, :message => "Не введён e-mail"

  validates_uniqueness_of :email,
    :message => "Пользователь с таким адресом уже зарегистрирован"

  validates_presence_of :nickname,
    :message => "Вы не ввели имя"

  validates_uniqueness_of :nickname,
    :message => "Пользователь с таким именем уже зарегистрирован"

  def member_of_any_team?
    !! team
  end

  def captain?
    member_of_any_team? && captain_of?(team)
  end

  def author_of?(game)
    game.author.id == self.id
  end

  def captain_of?(other_team)
    other_team.captain.id == id
  end

  def can_edit?(game)
    self.author_of?(game) || self.access_level?(:admin)
  end

  def get_access_level_label
    if self.access_level?(:admin) then return 'Администратор' end
    if self.access_level?(:organizer) then return 'Организатор' end
    if self.access_level?(:player) then return 'Игрок' end
  end
end
