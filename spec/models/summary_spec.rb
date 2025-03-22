# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Summary do
  let(:summary) { described_class.new(items:, title: 'blah') }

  let(:items) { [1, 2] }

  describe '#type' do
    subject(:type) { summary.type }

    context 'when items count is greater than or equal to 2' do
      it 'returns :upgrade' do
        expect(type).to be(:upgrade)
      end
    end

    context 'when items count is less than 2' do
      let(:items) { [1] }

      it 'returns :new' do
        expect(type).to be(:new)
      end
    end
  end
end
