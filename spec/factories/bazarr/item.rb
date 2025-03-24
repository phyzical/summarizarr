# frozen_string_literal: true

FactoryBot.define do
  factory :bazarr_item, class: Bazarr::Item::Thing.name do
    language { Faker::Language.name }
    title { Faker::Movie.title }
    series { Faker::Movie.title }
    episode_number { Faker::Number.decimal(l_digits: 2) }
    score { "#{Faker::Number.decimal(l_digits: 2)}%" }
    description { "downloaded from xyz with a score of #{score}." }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today).strftime('%d/%m/%Y') }
  end
end
