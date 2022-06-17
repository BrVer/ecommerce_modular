# frozen_string_literal: true

Rails.application.config.after_initialize do
  if ENV.fetch('COMMUNICATION_BACKEND') == 'active_support'
    config = YAML.load_file('config/subscriptions.yml')
    ActiveSupportSubscriptionAttacher.new(config).attach_subscriptions
  end
end
