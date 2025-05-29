# frozen_string_literal: true

FactoryBot.define do
  factory :mylar3_item, class: Mylar3::Item::Thing.name do
    event_type { Mylar3::Item::EVENT_TYPES.values.sample }
    comic { Faker::Book.title }
    issue { Faker::Number.number(digits: 2) }
    deletion? { Faker::Boolean.boolean }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
  end
end
