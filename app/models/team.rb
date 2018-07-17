# -*- encoding : utf-8 -*-
class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_many :game_passings, :inverse_of => :team
  has_many :game_entries, :class_name => "GameEntry"
  has_many :members, :class_name => "User"
  belongs_to :captain, :class_name => "User"
  mount_uploader :picture, TeamPictureUploader

  validates_uniqueness_of :name,
    :message => "Команда с таким названием уже существует"

  validates_presence_of :name,
    :message => "Название команды должно быть непустым"

  before_destroy :disconnect_team
  after_save :adopt_captain

  def self.available_for(user)
    existing_applications = TeamApplication.of_user(user).to_a
    Team.all.select {|team| existing_applications.find {|appl| appl.team.id === team.id }.nil? }
  end

  def current_level_in(game)
    game_passing = GamePassing.of(self, game)
    game_passing.try :current_level
  end

  def finished?(game)
    game_passing = GamePassing.of(self, game)
    !! game_passing.try(:finished?)
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  protected

  def disconnect_team
    self.members.to_a.each {|user| user.team = nil; user.save! }
  end

  def adopt_captain
    unless captain.nil?
      self.members << captain unless members.include?(captain)
    end
  end
end
