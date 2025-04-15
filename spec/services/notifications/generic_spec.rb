# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Generic do
    include MockRequests
    include StdoutHelper

    before do
      stub_sonarr
      allow(Sonarr::Service).to receive(:new).and_call_original
    end

    let(:service) { Sonarr::Service.new }

    describe '.notify' do
      subject(:notify) { described_class.notify(service:) }

      it 'prints the output, prints the grouping by date and how many items were processed' do
        output = capture_stdout { notify }
        expected_strings = [
          "Processed #{service.items.count} items",
          service.app_name,
          *service.grouped_items.keys.map(&:to_s)
        ]
        expect(output.scan(/#{Regexp.union(expected_strings)}/)).to match_array(expected_strings)
      end
    end
  end
end
