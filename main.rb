# frozen_string_literal: true

Dir[File.join(__dir__, 'app', '**', '**', '*.rb')].each { |file| require file }

def run
end

begin
  run
rescue StandardError => e
  Logs.log(type: :pp, log: API::QueueService.responses.last, error: true)
  Logs.log(type: :pp, log: e.backtrace.map { |x| x.gsub('/app', '') }, error: true)
  raise e
end

#  TODOS
#  - make some loose algo to workout next best type to action when we call a skill
#  - add multi threading for queue so that all characters can run at the same time might not be worth the complexity to save like ~3 seconds tops
