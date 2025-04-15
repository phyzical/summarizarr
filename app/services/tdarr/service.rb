# frozen_string_literal: true

module Tdarr
  class Service < BaseService
    def app_name
      'Tdarr'
    end

    def app_colour
      0x00FF00 # green
    end

    def summary
      size_before = items.reduce(0) { |sum, item| sum + item.size_before }.round(3)
      size_after = items.reduce(0) { |sum, item| sum + item.size_after }.round(3)
      size_difference = (size_before - size_after).round(3)
      "* Processed #{items.count} items\n" \
        "* Starting size: #{size_before} GB\n" \
        "* Ending size: #{size_after} GB\n" \
        "* Total Savings: #{size_difference} GB\n" \
        "* Average Savings: #{(size_difference / items.count).round(3)} GB\n"
    end

    private

    class << self
      def api_prefix
        '/api/v2'
      end

      # curl -X 'POST' 'http://tdarr/api/v2/client/jobs' -H 'accept: application/json' -H 'Content-Type: application/json' # rubocop:disable Layout/LineLength
      # -d '{"data":{"start":'"$i"',"pageSize":15,"filters":[{"id":"job.type", "value":"transcode"}, {"id": "status", "value":"Transcode success"}],"sorts":[],"opts":{}}}' \ # rubocop:disable Layout/LineLength
      def jobs_endpoint
        "#{api_prefix}/client/jobs"
      end

      # curl -X 'GET' 'http://tdarr/api/v2/status'   -H 'accept: application/json'
      def status_endpoint
        "#{api_prefix}/status"
      end
    end

    def pull(page: 1)
      page -= 1
      Request.perform(
        type: :post,
        url: "#{base_url}#{self.class.jobs_endpoint}",
        get_vars: get_vars(page:),
        headers:,
        body: body(page:)
      )[
        :array
      ]
    end

    def body(page: 0)
      {
        data: {
          start: page,
          pageSize: 15,
          filters: [{ id: 'job.type', value: 'transcode' }, { id: 'status', value: 'Transcode success' }],
          sorts: [],
          opts: {
          }
        }
      }
    end

    def map(json:)
      Item.from_json(json:)
    end

    def filter(*)
      true
    end

    def get_vars(page: 0)
      { page: }
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def app_config
      config.tdarr
    end

    def pull_app_name
      Request.perform(url: "#{base_url}#{self.class.status_endpoint}", headers:)[:status].present? ? app_name : 'N/A'
    end
  end
end
