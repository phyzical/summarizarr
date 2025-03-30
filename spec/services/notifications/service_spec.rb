# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Service do
    before { allow(Config.get).to receive(:sonarr).and_return(Config::NotificationConfig.new(**config)) }

    let(:config) { { webhook_url: Faker::Internet.url, enabled?: true } }

    describe '.notify' do
      context 'when discord is enabled' do
        it 'calls Discord::Notification.notify' do
          described_class.notify(contents: 'test')
        end
      end

      context 'when discord is disabled' do
        let(:config) { { webhook_url: nil, enabled?: false } }

        it 'calls Generic::Notification.notify' do
          described_class.notify(contents: 'test')
        end
      end
    end
  end
end
