# frozen_string_literal: true

require_relative 'app/services/main'

# :nocov:
Main.new.run if __FILE__ == $PROGRAM_NAME
# :nocov:
