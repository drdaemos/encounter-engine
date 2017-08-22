class TestChannel < ApplicationCable::Channel
def subscribed
    # current_user.appear
    stream_from "web_notifications_#{current_user.id}"
  end

  def unsubscribed
    # current_user.disappear
  end

  def appear(data)
    # current_user.appear on: data['appearing_on']
  end

  def away
    # current_user.away
  end
end