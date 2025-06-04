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
        expected_strings = [service.summary, service.class::APP_NAME, *service.grouped_items.keys.map(&:to_s)]
        expect(output.scan(/#{Regexp.union(expected_strings)}/)).to match_array(expected_strings)
        output = output.split("\n")
        duplicated_lines =
          output.group_by(&:itself).select { |line, occurrences| line.start_with?('*') && occurrences.size > 1 }.keys
        expect(output).not_to be_empty
        expect(duplicated_lines).to be_empty, "Duplicated lines found: \n#{duplicated_lines.join("\n")}"
      end
    end
  end
end
