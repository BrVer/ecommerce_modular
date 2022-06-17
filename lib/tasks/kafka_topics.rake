# frozen_string_literal: true

module Tasks
  class KafkaTopics
    include Rake::DSL

    KAFKA_TOPICS = %w[orders payments inventory].freeze

    def initialize # rubocop:disable Metrics/MethodLength
      namespace :kafka_topics do
        task reset: :environment do
          delete_kafka_topics
          create_kafka_topics
        end
        task delete: :environment do
          delete_kafka_topics
        end
        task create: :environment do
          create_kafka_topics
        end
      end
    end

    private

    def kafka_client
      @kafka_client ||= Kafka.new(ENV['KAFKA_SEED_BROKERS'].split(','))
    end

    def delete_kafka_topics
      KAFKA_TOPICS.each do |topic_name|
        kafka_client.delete_topic(topic_name)
        puts "topic #{topic_name} created"
      end
    end

    def create_kafka_topics
      KAFKA_TOPICS.each do |topic_name|
        kafka_client.create_topic(topic_name,
                                  num_partitions: 3, replication_factor: 1, config: { 'retention.ms' => 2_419_200_000 })
        puts "topic #{topic_name} created"
      end
    end
  end
end

Tasks::KafkaTopics.new
