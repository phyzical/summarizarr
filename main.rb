# frozen_string_literal: true

Dir[File.join(__dir__, 'app', '**', '**', '*.rb')].each { |file| require_relative file }

module Main
  def self.run
    summary = Summary::Service.generate
    pp summary
    summary
  end
end

# :nocov:
Main.run if __FILE__ == $PROGRAM_NAME
# :nocov:

#  TODOS
#  - make some loose algo to workout next best type to action when we call a skill
#  - add multi threading for queue so that all characters can run
#   at the same time might not be worth the complexity to save like ~3 seconds tops
