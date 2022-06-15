# frozen_string_literal: true

class SubscriptionAttacher
  def attach_activesupport_subscriptions(config)
    config.each do |subscribed_domain, emitted_events|
      subscription = "#{subscribed_domain.capitalize}::Subscription".constantize
      emitted_events.each do |domain, events_list|
        events_list.each { subscription.attach_to("#{domain}.#{_1}") }
      end
    end
  end
end
