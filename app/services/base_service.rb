# frozen_string_literal: true

class BaseService
  def initialize
    begin
      verify
    rescue StandardError => e
      @items = []
      puts e
      return
    end
    items
  end

  SEPARATOR = "\n----------------------------------------------------------------------------------------------------\n"
  DOT_POINT = "\n   * "

  def summary
    "#{SEPARATOR}                #{app_name} Summary:#{DOT_POINT}#{items.map(&:summary).join(DOT_POINT)}#{SEPARATOR}"
  end

  delegate :from_date, to: :config
  delegate :base_url, :api_key, to: :app_config

  # :nocov:
  def items
    raise 'Please implement!'
  end
  # :nocov:

  private

  def config
    @config ||= Config.get
  end

  # :nocov:
  def app_name
    raise 'Please implement!'
  end
  # :nocov:

  # :nocov:
  def app_config
    raise 'Please implement!'
  end
  # :nocov:

  # :nocov:
  def pull_app_name
    raise 'Please implement!'
  end
  # :nocov:

  def verify
    raise "#{app_name} URL is not set, will be skipped" if base_url.blank?
    found_app_name = pull_app_name
    return if found_app_name == app_name
    raise "Error this is not an instance of #{app_name} found (#{found_app_name}) Skipping"
  end
end
