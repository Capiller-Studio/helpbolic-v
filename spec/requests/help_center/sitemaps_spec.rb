# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::Sitemaps', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active, flags: 8) } # indexing_enabled

  before do
    set_tenant_host(domain)
  end

  describe 'GET /sitemap.xml' do
    it 'renders XML sitemap with published categories and articles' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)

        get '/sitemap.xml'

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('application/xml')
        expect(response.body).to include(category.slug || category.id)
        expect(response.body).to include(article.slug || article.id)
      end
    end

    it 'renders empty sitemap when indexing is disabled' do
      portal.update!(flags: 0)

      get '/sitemap.xml'

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('application/xml')
      expect(response.body).not_to include('/collections/')
      expect(response.body).not_to include('/articles/')
    end

    it 'includes contact_url only when contact form is enabled and channel is present' do
      account.with_shard do
        form = create(:channel_contact_form, account: account)
        portal.update!(show_contact_form: true, contact_form_channel: form)

        get '/sitemap.xml'
        expect(response.body).to include('/contact')

        portal.update!(show_contact_form: false)
        get '/sitemap.xml'
        expect(response.body).not_to include('/contact')
      end
    end

    it 'falls back to UUID when category or article has no slug' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)
        category.translations.destroy_all
        article.translations.destroy_all

        get '/sitemap.xml'
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(category.id)
        expect(response.body).to include(article.id)
      end
    end
  end
end
