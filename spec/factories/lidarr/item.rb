# frozen_string_literal: true

FactoryBot.define do
  factory :lidarr_item, class: Lidarr::Item::Thing.name do
    event_type { Lidarr::Item::EVENT_TYPES.values.sample }
    album { Faker::Music.album }
    title { Faker::Music::RockBand.song }
    artist { Faker::Music.band }
    image { Faker::Internet.url }
    deletion? { Faker::Boolean.boolean }
    quality { Faker::Quality.music }
  end
end
