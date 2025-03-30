# frozen_string_literal: true

FactoryBot.define do
  factory :radarr_item, class: Radarr::Item::Thing.name do
    event_type { Radarr::Item::EVENT_TYPES.values.sample }
    languages { Faker::Language.name }
    title { Faker::Movie.title }
    image { Faker::Internet.url }
    deletion? { Faker::Boolean.boolean }
    quality { Faker::Quality.tv }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
  end
end
