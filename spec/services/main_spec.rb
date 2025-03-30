# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Main do
  include MockRequests

  subject(:run) { described_class.run }

  before { stub_all }

  it 'runs' do
    expect(run).to include('Sonarr Summary', 'Radarr Summary')
  end
end
