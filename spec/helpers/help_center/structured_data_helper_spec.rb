# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::StructuredDataHelper, type: :helper do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let(:portal) { create(:help_center_portal, account: account, domain: domain, name: 'Deskbolic Support', hero_subtitle: 'Knowledge Base') }

  before do
    @current_portal = portal
    helper.extend described_class
    helper.extend HelpCenter::MetaTagsHelper
  end

  describe '#portal_structured_data' do
    it 'returns empty hash when portal is blank' do
      expect(helper.portal_structured_data(nil)).to eq({})
    end

    it 'returns valid WebSite schema' do
      data = helper.portal_structured_data(portal)

      expect(data['@context']).to eq('https://schema.org')
      expect(data['@type']).to eq('WebSite')
      expect(data['name']).to eq('Deskbolic Support')
      expect(data['description']).to eq('Knowledge Base')
    end
  end

  describe '#category_structured_data' do
    it 'returns empty hash when category is blank' do
      expect(helper.category_structured_data(nil)).to eq({})
    end

    it 'returns CollectionPage and BreadcrumbList graph' do
      account.with_shard do
        parent = create(:help_center_category, account: account, portal: portal, name: 'Guides')
        child = create(:help_center_category, account: account, portal: portal, name: 'Quick Start', parent: parent)

        data = helper.category_structured_data(child)

        expect(data['@context']).to eq('https://schema.org')
        expect(data['@graph']).to be_an(Array)

        collection = data['@graph'].find { |g| g['@type'] == 'CollectionPage' }
        expect(collection).to be_present
        expect(collection['name']).to eq('Quick Start')

        breadcrumbs = data['@graph'].find { |g| g['@type'] == 'BreadcrumbList' }
        expect(breadcrumbs).to be_present
        expect(breadcrumbs['itemListElement'].size).to eq(3) # Home -> Guides -> Quick Start
        expect(breadcrumbs['itemListElement'].pluck('name')).to eq([ 'Home', 'Guides', 'Quick Start' ])
      end
    end
  end

  describe '#article_structured_data' do
    it 'returns empty hash when article is blank' do
      expect(helper.article_structured_data(nil, portal)).to eq({})
    end

    it 'returns Article and BreadcrumbList graph' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Billing')
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'How to Pay', content: '<p>Pay here</p>')

        data = helper.article_structured_data(article, portal)

        expect(data['@context']).to eq('https://schema.org')
        expect(data['@graph']).to be_an(Array)

        art_schema = data['@graph'].find { |g| g['@type'] == 'Article' }
        expect(art_schema).to be_present
        expect(art_schema['headline']).to eq('How to Pay')
        expect(art_schema['description']).to include('Pay here')
        expect(art_schema['author']['name']).to eq('Deskbolic Support')
        expect(art_schema['publisher']['name']).to eq('Deskbolic Support')

        breadcrumbs = data['@graph'].find { |g| g['@type'] == 'BreadcrumbList' }
        expect(breadcrumbs).to be_present
        expect(breadcrumbs['itemListElement'].pluck('name')).to eq([ 'Home', 'Billing', 'How to Pay' ])
      end
    end
  end
end
