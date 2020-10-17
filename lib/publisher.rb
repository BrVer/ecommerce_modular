# frozen_string_literal: true

module Publisher
  module_function

  def broadcast(name, payload = {})
    separator = '-' * 80
    message = [
      separator,
      "publishing #{name} event with following payload:",
      JSON.pretty_generate(payload),
      separator
    ].join("\n")

    Rails.logger.info(message)
    events_logger.info(message)
    ActiveSupport::Notifications.instrument(name, payload)
  end

  def events_logger
    # TODO: get rid of class variable
    @@events_logger ||= ActiveSupport::Logger.new("#{Rails.root}/log/my.log")
  end
end
