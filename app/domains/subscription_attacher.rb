# frozen_string_literal: true

class SubscriptionAttacher
  def attach_activesupport_subscriptions(config)
    config.each do |subscribed_domain, emitted_events|
      subscription = "#{subscribed_domain.capitalize}::Subscription".constantize
      emitted_events.each do |domain, events_list|
        events_list.each do |event_name|
          ActiveSupport::Notifications.subscribe("#{domain}.#{event_name}") do |name, _start, _finish, _id, payload|
            method = name.tr('.', '_')
            subscription.new.send(method, payload) # TODO: why do we .new each time ?
          end
        end
      end
    end
  end
end
