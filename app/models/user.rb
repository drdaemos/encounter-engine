# -*- encoding : utf-8 -*-
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :nickname

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte, :google_oauth2, :yandex]


  bitmask :access_level, :as => [:player, :organizer, :admin]
  belongs_to :team
  has_many :created_games, :class_name => "Game", :foreign_key => "author_id"
  mount_uploader :avatar, UserAvatarUploader

  before_create :set_default_access_level

  validates_uniqueness_of :email,
    :message => "пользователь с таким адресом уже зарегистрирован"

  validates_presence_of :nickname,
    :message => "имя не может быть пустым"

  validates_uniqueness_of :nickname,
    :message => "пользователь с таким именем уже зарегистрирован"

  scope :without_team, -> { where(team_id: nil) }

  def self.free_players
    self.without_team
  end

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

  def member_of?(other_team)
    other_team.members.include?(self)
  end

  def can_edit?(game)
    self.author_of?(game) || self.access_level?(:admin)
  end

  def get_access_level_label
    if self.access_level?(:admin) then return 'Администратор' end
    if self.access_level?(:organizer) then return 'Организатор' end
    if self.access_level?(:player) then return 'Игрок' end
  end

  def should_generate_new_friendly_id?
    nickname_changed? || super
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  private

  def set_default_access_level
    self.access_level << :organizer
  end
end
