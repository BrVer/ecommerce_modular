# frozen_string_literal: true

class ActiveSupportSubscriptionAttacher
  def initialize(config)
    @config = config
  end

  def attach_subscriptions
    config.each do |subscribed_domain, emitted_events|
      subscription = "#{subscribed_domain.capitalize}::Subscription".constantize.new
      emitted_events.each do |events_domain, events_list|
        events_list.each { |event_name| attach(subscription, events_domain, event_name) }
      end
    end
  end

  private

  def attach(subscription, event_domain, event_name)
    ActiveSupport::Notifications.subscribe("#{event_domain}.#{event_name}") do |name, _start, _finish, _id, payload|
      method = name.tr('.', '_')
      payload.deep_stringify_keys! if payload.respond_to?(:deep_stringify_keys!) # this unifies the format between ActiveSupport and Kafka events
      subscription.send(method, payload)
    end
  end

  attr_reader :config
end
