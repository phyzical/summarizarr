# frozen_string_literal: true

class GenericArrService < BaseService
  def items
    @items ||= combine(combinable: process)
  end

  private

  class << self
    def api_version
      'v3'
    end

    def api_prefix
      "/api/#{api_version}"
    end

    def history_endpoint
      "#{api_prefix}/history"
    end

    def status_endpoint
      "#{api_prefix}/system/status"
    end
  end

  def pull(page: 1)
    Request.perform(url: "#{base_url}#{self.class.history_endpoint}", headers:, get_vars: get_vars(page:))[:records]
  end

  # :nocov:
  def filter(*)
    raise 'Please implement in subclass'
  end
  # :nocov:

  # :nocov:
  def map(*)
    raise 'Please implement in subclass'
  end
  # :nocov:

  def combine(combinable:)
    combinable
      .group_by(&:title)
      .values
      .filter_map do |items|
        old = items.find(&:deletion?)
        new = items.reject(&:deletion?).first
        next if new.nil?
        new.old_quality = old.quality if old
        new
      end
  end

  def get_vars(page: 1)
    { page:, pageSize: 15, sortDirection: 'descending', sortKey: 'date' }
  end

  def headers
    { Authorization: "Bearer #{api_key}" }
  end

  def pull_app_name
    Request.perform(url: "#{base_url}#{self.class.status_endpoint}", headers:)[:appName]
  end
end
