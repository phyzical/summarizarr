# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Main do
  subject(:run) { described_class.run }

  it 'runs' do
    expect { run }.not_to raise_error
  end
end
