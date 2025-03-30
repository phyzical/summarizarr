# frozen_string_literal: true

FactoryBot.define do
  factory :readarr_item, class: Readarr::Item::Thing.name do
    event_type { Readarr::Item::EVENT_TYPES.values.sample }
    title { Faker::Book.title }
    author { Faker::Book.author }
    image { Faker::Internet.url }
    deletion? { Faker::Boolean.boolean }
    quality { Faker::Quality.book }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
  end
end
