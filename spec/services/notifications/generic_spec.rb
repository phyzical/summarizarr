# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Generic do
    subject(:service) { described_class }
    let(:contents) { { message: 'Test message' } }

    describe '.notify' do
      subject(:notify) { service.notify(contents:) }
      it 'prints the contents' do
        expect { notify }.to output(/Test message/).to_stdout
      end
    end
  end
end
