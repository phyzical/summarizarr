# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Main do
  include MockRequests

  subject(:run) { described_class.new.run }

  before do
    stub_all
    i = 0
    allow_any_instance_of(described_class).to receive(:sleep).and_wrap_original do |_method, *_args| # rubocop:disable RSpec/AnyInstance
      i += 1
      raise 'TestExit' if i == max_runs
    end
  end

  let(:sonarr_service) { Sonarr::Service.new }
  let(:sleep_time) { 60 * 60 * 24 * 7 } # 7 days of seconds
  let(:max_runs) { 1 }

  it 'runs' do
    expect { run }.to output(/Sleeping for #{sleep_time}.0 seconds/).to_stdout.and raise_error('TestExit')
  end
end
