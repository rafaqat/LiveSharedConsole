class ConsoleChannel < ApplicationCable::Channel
  def subscribed
    return if room_id.blank?
    # RoomCreator.new(room_id, current_user).call disable for now
    stream_from "console_stream_#{room_id}"
    UserJoiner.new(room_id, current_user).call
  end

  def unsubscribed
    return if room_id.blank?
    UserLeaver.new(room_id, current_user).call
    # RoomDestroyer.new(room_id, current_user).call disable for now
  end

  def receive(data)
    return if room_id.blank?
    result = ActionPerformer.new(room_id, data).call

    OutputUpdater.new(
      room_id: room_id,
      user:    current_user,
      code:    data["code"],
      result:  result
    ).call
  end

  private

  def room_id
    params[:id]
  end
end
