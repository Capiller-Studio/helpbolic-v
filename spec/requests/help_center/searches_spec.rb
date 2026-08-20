# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::Searches', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

  before do
    set_tenant_host(domain)
  end

  describe 'GET /search' do
    it 'renders the search page with default articles when query is empty' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)

        get search_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(article.title)
      end
    end

    it 'renders search results when query is provided' do
      account.with_shard do
        allow(HelpCenter::Article).to receive(:search).and_return(
          double('SearchkickResults', total_count: 0, map: [], to_a: [], empty?: true)
        )
        allow(HelpCenter::Category).to receive(:search).and_return(
          double('SearchkickResults', total_count: 0, map: [], to_a: [], empty?: true)
        )

        get search_path, params: { query: 'billing' }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /search/suggestions' do
    it 'returns empty JSON suggestions when query is blank' do
      get search_suggestions_path

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json).to eq({ 'articles' => [], 'categories' => [] })
    end

    it 'returns JSON suggestions for a query' do
      allow(HelpCenter::Article).to receive(:search).and_return([])
      allow(HelpCenter::Category).to receive(:search).and_return([])

      get search_suggestions_path, params: { query: 'setup' }

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json).to have_key('articles')
      expect(json).to have_key('categories')
    end
  end
end
