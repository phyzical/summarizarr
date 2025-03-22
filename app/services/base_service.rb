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
    raise 'Not implemented'
  end

  private

  def config
    @config ||= Config.get
  end

  def app_name
    raise 'Not implemented'
  end

  def app_config
    raise 'Not implemented'
  end

  def verify
    raise "#{app_name} URL is not set, will be skipped" if base_url.blank?
    raise "#{app_name} API Key is not set, will be skipped" if api_key.blank?
  end
end
