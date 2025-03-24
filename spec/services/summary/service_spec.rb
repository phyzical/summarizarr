# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Summary::Service do
  include MockRequests

  describe '#generate' do
    subject(:generate) { described_class.generate }

    before { stub_all }

    it 'returns a string' do
      expect(generate).to match(a_string_including(''))
    end
  end
end
