# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'simplecov' if ENV['COVERAGE']
require_relative '../main'
require 'rspec'
require 'factory_bot'
require 'faker'
require 'webmock/rspec'
require 'rubocop-rspec'
require 'rubocop-factory_bot'

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |file| require_relative file }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) { FactoryBot.find_definitions }
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
