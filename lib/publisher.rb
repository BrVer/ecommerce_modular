# frozen_string_literal: true

module Publisher
  module_function

  def broadcast(domain, event, payload:, partition_key: nil)
    log_event(domain, event, payload: payload)
    send_to_kafka(domain, event, payload: payload, partition_key: partition_key)
    send_activesupport_notification(domain, event, payload: payload)
  end

  def log_event(domain, event, payload:)
    separator = '-' * 80
    message = [
      separator,
      "publishing #{domain}.#{event} event with following payload:",
      JSON.pretty_generate(payload),
      separator
    ].join("\n")

    Rails.logger.info(message)
    events_logger.info(message)
  end

  def send_to_kafka(domain, event, payload:, partition_key: nil)
    partition_key ||= payload['id']
    raise RuntimeError unless partition_key

    WaterDrop::SyncProducer.call({ event: event, payload: payload }.to_json,
                                 topic: domain, partition_key: partition_key.to_s)
  end

  def send_activesupport_notification(domain, event, payload:)
    ActiveSupport::Notifications.instrument("#{domain}.#{event}", payload)
  end

  def events_logger
    # TODO: get rid of class variable
    @@events_logger ||= ActiveSupport::Logger.new("#{Rails.root}/log/events.log")
  end
end
