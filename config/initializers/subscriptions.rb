# frozen_string_literal: true

Rails.application.config.after_initialize do
  subscriptions_file = 'config/subscriptions.yml'

  if File.exist?(subscriptions_file)
    config = YAML.load_file(subscriptions_file)

    #TODO: only if not in Kafka mode!
    SubscriptionAttacher.new.attach_activesupport_subscriptions(config)
  end
end
