# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Discord do
    let(:contents) { { message: 'Test message' } }

    describe '.notify' do
      it 'prints the contents' do
        expect { described_class.notify(contents:) }.to output(/Test message/).to_stdout
      end
    end
  end
end
