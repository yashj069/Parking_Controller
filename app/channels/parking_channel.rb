class ParkingChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'parking_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
