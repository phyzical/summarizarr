# frozen_string_literal: true

require 'dotenv/load' if %w[production development].include?(ENV.fetch('RAILS_ENV', 'production'))
require 'uri'
require 'net/http'
require 'active_support/all'
require 'prettyprint'
if ENV.fetch('RAILS_ENV', 'production') == 'development'
  require 'rubocop'
  require 'rubocop-rake'
  require 'rubocop-performance'
end
