# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Radarr::Service do
  include MockRequests
  subject(:items) { service.items }

  let(:service) { described_class.new }

  before { stub_radarr }

  it 'returns history only containing expected types and groups by title' do
    expect(items.count).to be(2)
    expect(items).to all(be_a(Summary::Item::Thing))
  end
end
