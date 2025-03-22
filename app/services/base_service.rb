# frozen_string_literal: true

class BaseService
  def initialize
    verify
    items
  end

  SEPARATOR = "\n----------------------------------------------------------------------------------------------------\n"
  DOT_POINT = "\n   * "

  def summary
    "#{SEPARATOR}                #{app_name} Summary:#{DOT_POINT}#{items.map(&:summary).join(DOT_POINT)}#{SEPARATOR}"
  end

  delegate :from_date, to: :config
  delegate :base_url, :api_key, to: :app_config

  private

  def config
    @config ||= Config.get
  end

  def app_name
    raise 'Not implemented'
  end

  def verify
    warn "#{app_name} URL is not set" if base_url.blank?
    warn "#{app_name} API Key is not set" if api_key.blank?
  end
end
