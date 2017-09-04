# -*- encoding : utf-8 -*-
class Hint < ApplicationRecord
  belongs_to :level

  def penalty_time_in_minutes
    self.penalty_time.nil? ? nil : self.penalty_time / 60
  end

  def penalty_time_in_minutes=(value)
    self.penalty_time = value.to_i * 60
  end  

  def delay_in_minutes
    self.delay.nil? ? nil : self.delay / 60
  end

  def delay_in_minutes=(value)
    self.delay = value.to_i * 60
  end

  def ready_to_show?(current_level_entered_at)
    seconds_passed = Time.now - current_level_entered_at
    seconds_passed >= self.delay
  end

  def available_in(current_level_entered_at)
    (current_level_entered_at - Time.now).to_i + self.delay
  end

  def availability_date(current_level_entered_at)
    Time.at((current_level_entered_at).to_i + self.delay)
  end
end
