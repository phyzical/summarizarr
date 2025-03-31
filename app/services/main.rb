# frozen_string_literal: true

class Main
  def run
    last_run_time = nil
    loop do
      if last_run_time
        sleep_time = rerun_datetime.to_f - DateTime.now.to_f
        puts "Sleeping for #{sleep_time} seconds"
        sleep(sleep_time)
      end
      Notifications::Service.notify(contents: Summary::Service.generate)
      last_run_time = DateTime.now
    end
  end

  private

  delegate :rerun_datetime, to: :config

  def config
    @config ||= Config.get
  end
end
