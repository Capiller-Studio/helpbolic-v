# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StructuredDataHelper, type: :helper do
  before do
    helper.extend described_class
  end

  describe '#default_structured_data' do
    it 'returns Organization, WebSite, and SoftwareApplication schema graph' do
      data = helper.default_structured_data

      expect(data['@context']).to eq('https://schema.org')
      expect(data['@graph']).to be_an(Array)
      types = data['@graph'].pluck('@type')
      expect(types).to include('Organization', 'WebSite', 'SoftwareApplication')

      org = data['@graph'].find { |g| g['@type'] == 'Organization' }
      expect(org['name']).to eq('TECHBOLIC, LLC')

      website = data['@graph'].find { |g| g['@type'] == 'WebSite' }
      expect(website['name']).to eq('Capiller Rely Help')

      software = data['@graph'].find { |g| g['@type'] == 'SoftwareApplication' }
      expect(software['name']).to eq('Capiller Rely Help')
    end
  end
end
