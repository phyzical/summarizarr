# frozen_string_literal: true

FactoryBot.define do
  factory :tdarr_item, class: Tdarr::Item::Thing.name do
    event_type { Tdarr::Item::EVENT_TYPES.values.sample }
    file { Faker::File.file_name(dir: '/tmp') }
    title { Faker::Movie.title }
    series { Faker::Theater.play }
    season { Faker::Number.number(digits: 2) }
    deletion? { Faker::Boolean.boolean }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    size_before { Faker::File.filesize_in_gb }
    size_after { Faker::File.filesize_in_gb }
    size_ratio { "#{Faker::Number.decimal(l_digits: 2)}%" }
  end
end
