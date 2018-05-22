# -*- encoding : utf-8 -*-
class Game < ApplicationRecord
  serialize :preserved_data, Hash

  belongs_to :author, :class_name => "User"
  has_many :levels, -> { order('position') }
  has_many :logs, -> { order('time') }
  has_many :game_entries
  has_many :game_passings, :inverse_of => :game
  mount_uploader :poster, GamePosterUploader

  validates_presence_of :name,
    :message => I18n.t(:"activerecord.errors.messages.blank")

  validates_uniqueness_of :name,
    :message => I18n.t(:"activerecord.errors.messages.taken")

  validates_presence_of :description,
    :message => I18n.t(:"activerecord.errors.messages.blank")

  validates_numericality_of :max_team_number, :greater_than => 0, :less_than => 10000,
    :message => "диапазон количества команд от 1 до 10000"

  validates_presence_of :author

  validate :game_starts_in_the_future
  validate :valid_max_num

  validate :deadline_is_in_future
  validate :deadline_is_before_game_start

  validate :finish_time_is_in_future
  validate :finish_time_is_after_game_start

  default_scope { order(created_at: :desc) }
  scope :by, ->(author) { where(author_id: author) }
  scope :non_drafts, -> { where(is_draft: false) }
  scope :ready, -> { where(author_finished_at: nil) }
  scope :finished, -> { where.not(author_finished_at: nil) }
  scope :published, -> { where.not(author_finished_at: nil).where(is_published: true) }

  def self.started
    Game.all.select(&:started?)
  end

  def self.not_started
    Game.all.select { |game| !game.started? }
  end

  def self.available_for(user)
    Game.all.select {|game| game.is_available_for?(user) }
  end

  def self.edited_by(user)
    Game.all.select {|game| user.can_edit?(game) }
  end

  def self.tested_by(user)
    Game.all.select {|game| user.can_edit?(game) && game.is_testing? && game.started? }
  end

  def self.edited_and_finished(user)
    Game.all.select {|game| user.can_edit?(game) && game.finished? }
  end

  def self.active(user)
    Game.started - Game.finished
  end

  def self.results_available_for(user)
    games = Game.published

    unless user.nil?
      games = games + Game.tested_by(user) + Game.edited_and_finished(user)
    end

    return games.uniq
  end

  def author_finished?
    !self.author_finished_at.nil?
  end

  def is_testing?
    self.is_testing
  end

  def draft?
    self.is_draft
  end

  def published?
    self.is_published
  end

  def started?
    self.starts_at.nil? ? false : Time.now > self.starts_at
  end

  def finished?
    self.finished_at.nil? ? false : (Time.now > self.finished_at) || self.author_finished_at
  end

  def created_by?(user)
    user.author_of?(self)
  end

  def is_available_for?(user)
    !self.finished? && ((!self.draft? && !self.starts_at.nil?) || (!user.nil? && user.can_edit?(self)))
  end

  def can_be_played_by?(user)
    team = user.team
    !team.nil? && !GameEntry.with_status('accepted').of(team, self).nil?
  end

  def is_played_by?(user)
    team = user.team
    game_passing = user.team ? GamePassing.of(team, self) : nil
    !self.finished? && !game_passing.nil? && !game_passing.finished?
  end

  def can_request?
    self.requested_teams_number < self.max_team_number
    Game.all.select {|game| !game.started?}
  end

  def registration_open?
    deadline = self.registration_deadline.empty? ? self.starts_at : self.registration_deadline
    Time.now < deadline
  end

  def finished_teams
    GamePassing.of_game(self).finished.map(&:team)
  end

  def free_place_of_team!
    if self.requested_teams_number>0
      self.requested_teams_number-=1
      self.save
    end
  end

  def reserve_place_for_team!
    self.requested_teams_number+=1;
    self.save
  end

protected

  def game_starts_in_the_future
    if self.author_finished_at.nil? and self.starts_at and self.starts_at < Time.now
      self.errors.add(:starts_at, "Вы выбрали дату начала игры из прошлого")
    end
  end

  def valid_max_num
    if self.max_team_number
      if self.max_team_number < self.requested_teams_number
        self.errors.add(:max_team_number, "Количество команд, подавших заявку превышает заданное число")
      end
    end
  end

  def deadline_is_in_future
    if self.author_finished_at.nil? and self.registration_deadline and self.registration_deadline < Time.now
        self.errors.add(:registration_deadline,"Вы указали крайний срок регистрации из прошлого")
    end
  end
  def deadline_is_before_game_start
    if self.registration_deadline and
        self.starts_at and self.registration_deadline > self.starts_at
      self.errors.add(:registration_deadline,"Вы указали крайний срок регистрации позже даты начала игры")
    end
  end

  def finish_time_is_in_future
    if self.author_finished_at.nil? and self.finished_at and self.finished_at < Time.now
      self.errors.add(:finished_at,"Вы указали время окончания из прошлого")
    end
  end
  def finish_time_is_after_game_start
    if self.finished_at and self.starts_at and self.starts_at > self.finished_at
      self.errors.add(:finished_at,"Вы указали время окончания до начала игры")
    end
  end
end
