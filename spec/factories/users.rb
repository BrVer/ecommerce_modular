# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { "employee_#{_1}@example.com" }
  end
end
