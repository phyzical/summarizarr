# frozen_string_literal: true

FactoryBot.define do
  factory :sonarr_item, class: Sonarr::Item::Thing.name do
    event_type { Sonarr::Item::EVENT_TYPES.values.sample }
    languages { Faker::Language.name }
    series { Faker::Theater.play }
    title { Faker::Theater.play }
    image { Faker::Internet.url }
    deletion? { Faker::Boolean.boolean }
    episode { Faker::Number.number(digits: 2) }
    season { Faker::Number.number(digits: 2) }
    quality { Faker::Quality.tv }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
  end
end
