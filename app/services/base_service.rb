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

  def items
    @items ||= process
  end

  private

  def process
    page = 1
    items = []
    loop do
      pull = pull(page:)
      # :nocov:
      break if pull.empty?
      # :nocov:
      items += pull.map { |json| map(json:) }
      page += 1
      break if items.last.date < from_date
    end
    items.filter { |item| item.date >= from_date && filter(item:) }
  end

  # :nocov:
  def pull(page: 1) # rubocop:disable Lint/UnusedMethodArgument
    raise 'Please implement!'
  end
  # :nocov:

  # :nocov:
  def map
    raise 'Please implement!'
  end
  # :nocov:

  def filter(item:)
    self.class.module_parent::Item::EVENT_TYPES.value?(item.event_type)
  end

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
