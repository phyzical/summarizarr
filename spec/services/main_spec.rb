# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Main do
  include MockRequests
  include StdoutHelper

  subject(:run) { described_class.new.run }

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('RERUN_INTERVAL_DAYS', '').and_return('7')
    stub_all
    i = 0
    allow_any_instance_of(described_class).to receive(:sleep).and_wrap_original do |_method, *_args| # rubocop:disable RSpec/AnyInstance
      i += 1
      raise 'TestExit' if i == max_runs
    end
  end

  let(:sleep_time) { 60 * 60 * 24 * 7 } # 7 days of seconds
  let(:max_runs) { 1 }

  it 'runs' do
    expect { run }.to output(/Sleeping for #{sleep_time}.0 seconds/).to_stdout.and raise_error('TestExit')
  end

  context 'when ignoring rerun for testing' do
    before { allow(ENV).to receive(:fetch).with('RERUN_INTERVAL_DAYS', '').and_return('') }

    it 'doesn\'t duplicate' do
      output = capture_stdout { run }.split("\n")
      duplicated_lines =
        output
          .group_by(&:itself)
          .select { |line, occurrences| !line.include?('Upgrades: 0') && line.start_with?('*') && occurrences.size > 1 }
          .keys
      expect(output).not_to be_empty
      expect(duplicated_lines).to be_empty, "Duplicated lines found: \n#{duplicated_lines.join("\n")}"
    end
  end
end
