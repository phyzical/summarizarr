# frozen_string_literal: true

Dir[File.join(__dir__, 'app', '**', '**', '*.rb')].each do |file|
  require_relative file unless file.include?('summary/service')
end
# must be loaded last
require_relative 'app/services/summary/service'

# :nocov:
Main.new.run if __FILE__ == $PROGRAM_NAME
# :nocov:
