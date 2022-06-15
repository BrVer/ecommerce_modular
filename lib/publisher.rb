# frozen_string_literal: true

module Publisher
  module_function

  def broadcast(domain, event, payload = {})
    separator = '-' * 80
    message = [
      separator,
      "publishing #{domain}.#{event} event with following payload:",
      JSON.pretty_generate(payload),
      separator
    ].join("\n")

    Rails.logger.info(message)
    events_logger.info(message)
    ActiveSupport::Notifications.instrument("#{domain}.#{event}", payload)
  end

  def events_logger
    # TODO: get rid of class variable
    @@events_logger ||= ActiveSupport::Logger.new("#{Rails.root}/log/events.log")
  end
end
