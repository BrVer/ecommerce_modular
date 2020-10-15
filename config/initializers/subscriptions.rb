# frozen_string_literal: true

Rails.application.config.after_initialize do
  SubscriptionAttacher.new.attach_subscriptions
end
