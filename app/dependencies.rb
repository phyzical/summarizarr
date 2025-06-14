# frozen_string_literal: true

# :nocov:
require 'dotenv/load' if %w[production development].include?(ENV.fetch('RAILS_ENV', 'production'))
# :nocov:

require 'uri'
require 'net/http'
require 'active_support/all'
require 'prettyprint'
require 'tzinfo'
# :nocov:
if ENV.fetch('RAILS_ENV', 'production') == 'development'
  require 'rubocop'
  require 'rubocop-rake'
  require 'rubocop-performance'
end

Time.zone = 'UTC' if !Time.now.zone || ENV.fetch('RAILS_ENV', 'production') == 'test'
# :nocov:

# Load all services except summary service
Dir[File.join(__dir__, '**', '**', '*.rb')].each do |file|
  require_relative file unless file.include?('summary/service')
end

# must be loaded last
require_relative 'services/summary/service'
