# -*- encoding : utf-8 -*-
class Game < ApplicationRecord
  serialize :preserved_data, Hash

  belongs_to :author, :class_name => "User"
  has_many :levels, -> { order('position') }
  has_many :logs, -> { order('time') }
  has_many :game_entries, :class_name => "GameEntry"
  has_many :game_passings, :class_name => "GamePassing"
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

  scope :by, ->(author) { where(author_id: author) }
  scope :non_drafts, -> { where(is_draft: false) }
  scope :finished, -> { where.not(author_finished_at: nil) }

  def self.started
    Game.all.select(&:started?)
  end

  def draft?
    self.is_draft
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

  def finished_teams
    GamePassing.of_game(self).finished.map(&:team)
  end

  def place_of(team)
    game_passing = GamePassing.of(team, self)
    return nil unless game_passing and game_passing.finished?

    count_of_finished_before = GamePassing.of_game(self).finished_before(game_passing.finished_at).count
    count_of_finished_before + 1
  end

  def self.notstarted
    Game.all.select { |game| !game.draft? && !game.started? }
  end  

  def self.available_previews
    Game.all.select { |game| !game.draft? && !game.finished? }
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

  def can_request?
    self.requested_teams_number < self.max_team_number
    Game.all.select {|game| !game.started?}
  end

  def finish_game!
    self.author_finished_at = Time.now
    self.save!
  end

  def author_finished?
    !self.author_finished_at.nil?
  end

  def is_testing?
    self.is_testing
  end

protected

  def game_starts_in_the_future
    if self.author_finished_at.nil? and self.starts_at and self.starts_at < Time.now
      self.errors.add(:starts_at, "Вы выбрали дату из прошлого. Так нельзя :-)")
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
        self.errors.add(:registration_deadline,"Вы указали крайний срок регистрации из прошлого, так нельзя :-)")
    end
  end
  def deadline_is_before_game_start
    if self.registration_deadline and
        self.starts_at and self.registration_deadline > self.starts_at
      self.errors.add(:registration_deadline,"Вы указали крайний срок регистрации больше даты начала игры, так нельзя :-)")
    end
  end
end
