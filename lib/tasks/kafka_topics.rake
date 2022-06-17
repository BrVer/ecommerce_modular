# frozen_string_literal: true

module Tasks
  class KafkaTopics
    include Rake::DSL

    KAFKA_TOPICS = %w[orders payments inventory].freeze

    def initialize
      namespace :kafka_topics do
        task reset: :environment do
          reset_kafka_topics
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
      @kafka_client ||= Kafka.new(['kafka://127.0.0.1:9092']) # TODO: fetch from the ENV
    end

    def reset_kafka_topics
      delete_kafka_topics
      create_kafka_topics
    end

    def delete_kafka_topics
      KAFKA_TOPICS.each { kafka_client.delete_topic(_1) }
    end

    def create_kafka_topics
      KAFKA_TOPICS.each do |topic_name|
        kafka_client.create_topic(topic_name,
                                  num_partitions: 3, replication_factor: 1, config: { 'retention.ms' => 2_419_200_000 })
      end
    end
  end
end

Tasks::KafkaTopics.new
