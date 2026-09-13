# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::ApplicationHelper, type: :helper do
  it 'includes Pagy::Frontend' do
    expect(described_class.ancestors).to include(Pagy::Frontend)
  end
end
