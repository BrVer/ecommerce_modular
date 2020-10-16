# frozen_string_literal: true

class Subscription
  def call(message, _, _, _, payload)
    method = message.tr('.', '_')
    send(method, payload)
  end

  def self.attach_to(event_name)
    ActiveSupport::Notifications.subscribe event_name.to_s, new
  end
end
