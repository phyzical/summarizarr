# frozen_string_literal: true

# :nocov:
require 'dotenv/load' if %w[production development].include?(ENV.fetch('RAILS_ENV', 'production'))
# :nocov:

require 'uri'
require 'net/http'
require 'active_support/all'
require 'prettyprint'
# :nocov:
if ENV.fetch('RAILS_ENV', 'production') == 'development'
  require 'rubocop'
  require 'rubocop-rake'
  require 'rubocop-performance'
end
# :nocov:

Time.zone = Time.find_zone!(Time.now.zone) || 'UTC'
