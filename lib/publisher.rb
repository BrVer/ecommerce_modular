# frozen_string_literal: true

module Publisher
  module_function

  def broadcast(name, payload = {})
    Rails.logger.info("publishing #{name} event with following payload:\n#{payload}")
    ActiveSupport::Notifications.instrument(name, payload)
  end
end
