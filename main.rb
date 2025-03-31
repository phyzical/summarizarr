# frozen_string_literal: true

Dir[File.join(__dir__, 'app', '**', '**', '*.rb')].each { |file| require_relative file }

# :nocov:
Main.new.run if __FILE__ == $PROGRAM_NAME
# :nocov:
