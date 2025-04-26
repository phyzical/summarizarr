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

  PRIMARY_GROUP_CONTEXT = :series
  SECONDARY_GROUP_CONTEXT = :season
  FALLBACK_GROUP_CONTEXT = :date
  ITEM_SORT_CONTEXT = :title

  def grouped_items
    @grouped_items ||=
      sort_and_group(items, self.class::PRIMARY_GROUP_CONTEXT).transform_values do |primary_groups|
        sort_and_group(primary_groups, self.class::SECONDARY_GROUP_CONTEXT).transform_values do |secondary_groups|
          sort_and_group(secondary_groups, self.class::FALLBACK_GROUP_CONTEXT).transform_values do |fallback_groups|
            fallback_groups.sort_by { |item| item[self.class::ITEM_SORT_CONTEXT] || '' }
          end
        end
      end
  end

  delegate :from_date, to: :config
  delegate :base_url, :api_key, to: :app_config

  def items
    @items ||= process
  end

  # :nocov:
  def summary
    raise 'Please implement!'
  end
  # :nocov:

  private

  def process # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    page = 1
    items = []
    loop do
      pulls = pulls(page:)
      # :nocov:
      break if pulls.all?(&:empty?)
      # :nocov:
      pulls = pulls.map { |pull| pull.map { |json| map(json:) } }
      items += pulls.flatten
      page += 1
      break if pulls.all? { |pull| pull.any? { |item| item.date < from_date } }
    end
    items.filter { |item| item.date >= from_date && filter(item:) }
  end

  # :nocov:
  def pulls(page: 1) # rubocop:disable Lint/UnusedMethodArgument
    raise 'Please implement!'
  end
  # :nocov:

  def map(json:)
    self.class.module_parent::Item.from_json(json:)
  end

  def filter(item:)
    self.class.module_parent::Item::EVENT_TYPES.value?(item.event_type)
  end

  def config
    @config ||= Config.get
  end

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
    raise "#{self.class::APP_NAME} URL is not set, will be skipped" if base_url.blank?
    found_app_name = pull_app_name
    return if found_app_name == self.class::APP_NAME
    raise "Error this is not an instance of #{self.class::APP_NAME} found (#{found_app_name}) Skipping"
  end

  def sort_and_group(items, context)
    return { nil => items } if context.nil?
    items.sort_by { |item| item[context] || '' }.group_by { |item| item[context] }
  end
end
