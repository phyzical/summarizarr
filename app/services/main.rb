# frozen_string_literal: true

class Main
  def run
    last_run_time = nil
    loop do
      if last_run_time
        sleep_time = last_run_time + rerun_date - Time.now
        if sleep_time.positive?
          puts "Sleeping for #{sleep_time} seconds"
          sleep(sleep_time)
        end
      end
      contents = Summary::Service.new.generate
      Notifications::Service.new.notify(contents:)
      last_run_time = Time.now
    end
  end

  private

  delegate :rerun_date, to: :config

  def config
    @config ||= Config.get
  end
end
