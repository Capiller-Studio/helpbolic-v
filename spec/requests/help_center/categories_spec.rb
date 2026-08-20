# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::Categories', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

  before do
    set_tenant_host(domain)
  end

  describe 'GET /collections' do
    it 'renders the collections index page' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)

        get categories_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(category.name)
      end
    end
  end

  describe 'GET /collections/:id' do
    it 'renders a category by UUID with articles and sibling categories' do
      account.with_shard do
        parent = create(:help_center_category, account: account, portal: portal, name: 'Billing', status: :active)
        sibling = create(:help_center_category, account: account, portal: portal, name: 'Account Settings', status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: parent, title: 'How to pay invoices', status: :published)
        parent.articles << article

        get category_path(id: parent.id)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(parent.name)
        expect(response.body).to include(article.title)
        expect(response.body).to include(sibling.name)
      end
    end

    it 'renders subcategories when present' do
      account.with_shard do
        parent = create(:help_center_category, account: account, portal: portal, name: 'Platform', status: :active)
        subcategory = create(:help_center_category, account: account, portal: portal, name: 'API Integrations', parent: parent, status: :active)

        get category_path(id: parent.id)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(subcategory.name)
      end
    end

    it 'renders a category by translation slug' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Billing', status: :active)

        get category_path(id: category.slug || category.id)

        expect(response).to have_http_status(:ok)
      end
    end

    it 'supports turbo stream format for category show pagination' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)

        get category_path(id: category.id), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
      end
    end

    it 'returns 404 for non-existent category' do
      get category_path(id: '00000000-0000-0000-0000-000000000000')

      expect(response).to have_http_status(:not_found)
    end
  end
end
