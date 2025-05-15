# frozen_string_literal: true

require 'spec_helper'

module Mylar3
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read(
            "spec/support/requests/mylar3#{Service.api_prefix}?cmd=#{Service.history_cmd}.json",
            encoding: 'bom|utf-8'
          ),
          symbolize_names: true
        )[
          :data
        ]
      end

      context 'when item is downloadImported' do
        let(:json) { full_json.find { |x| x[:Status] == described_class::EVENT_TYPES[:post_processed] } }

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              event_type: described_class::EVENT_TYPES[:post_processed],
              date: Date.parse('25/03/2025'),
              comic: 'The Walking Dead Deluxe',
              issue: 109,
              deletion?: false
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:mylar3_item) }

      it 'when no old_quality' do
        expect(summary).to eq("issue: #{item.issue} has downloaded")
      end
    end
  end
end
