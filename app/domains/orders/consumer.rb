# frozen_string_literal: true

module Orders
  class Consumer < Karafka::BaseConsumer
    DOMAIN = 'orders'

    def consume
      send(:"consume_topic_#{topic_name}")
    end

    private

    def consume_topic_inventory
      return unless relevant_events_from('inventory').include?(event_name)

      call_subscription
    end

    def consume_topic_payments
      return unless relevant_events_from('payments').include?(event_name)

      call_subscription
    end

    def call_subscription
      Subscription.new.send("#{topic_name}_#{event_name}", event_payload)
    end

    def topic_name
      params.topic
    end

    def event_name
      params.payload['event']
    end

    def event_payload
      params.payload['payload']
    end

    def relevant_events_from(topic)
      subscribed_to[topic]
    end

    def subscribed_to
      subscriptions_file = 'config/subscriptions.yml'

      raise RuntimeError unless File.exist?(subscriptions_file)

      @subscribed_to ||= YAML.load_file(subscriptions_file)[DOMAIN]
    end
  end
end
