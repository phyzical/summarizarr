# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Summary::Item do
  let(:summary_class) { described_class.new(items:, title:) }

  let(:items) { build_list(FactoryBot.factory_by_class(Sonarr::Item::Thing), 2, title: title, series: title) }
  let(:title) { 'blah' }
  let(:new_quality) { '1440p' }
  let(:old_quality) { '1080p' }

  describe '#summary' do
    subject(:summary) { summary_class.summary }

    context 'when there is an upgrade' do
      let(:items) do
        [
          build(
            FactoryBot.factory_by_class(Sonarr::Item::Thing),
            deletion?: false,
            quality: new_quality,
            title: title,
            series: title
          ),
          build(
            FactoryBot.factory_by_class(Sonarr::Item::Thing),
            deletion?: true,
            quality: old_quality,
            title: title,
            series: title
          )
        ]
      end

      it 'returns a summary' do
        expect(summary).to eq("#{title} has upgraded from #{old_quality} to #{new_quality}")
      end
    end

    context 'when there is no upgrade' do
      let(:items) do
        [
          build(
            FactoryBot.factory_by_class(Sonarr::Item::Thing),
            deletion?: false,
            quality: new_quality,
            title: title,
            series: title
          )
        ]
      end

      it 'returns a summary' do
        expect(summary).to eq("#{title} has downloaded at #{new_quality}")
      end
    end
  end
end
