# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    title { Faker::Restaurant.name }
    description { Faker::Restaurant.review }
  end
end
