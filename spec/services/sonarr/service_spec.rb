# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sonarr::Service do
  include MockRequests
  subject(:items) { service.items }

  let(:service) { described_class.new }

  before { stub_endpoint('http://sonarr:8989/api/v3/history/since') }

  it 'returns history only containing expected types' do
    expect(items.count).to be(3)
    expect(items).to all(be_a(Sonarr::Episode::Thing))
  end
end
