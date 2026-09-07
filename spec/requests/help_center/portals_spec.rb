# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::Portals', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active, default_locale: 'en', locales: %w[en es fr]) }

  before do
    set_tenant_host(domain)
  end

  describe 'GET / (Portal homepage)' do
    it 'renders the portal homepage successfully with featured categories and articles' do
      account.with_shard do
        featured_cat = create(:help_center_category, account: account, portal: portal, name: 'Getting Started', status: :active, featured: true)
        unfeatured_cat = create(:help_center_category, account: account, portal: portal, name: 'Hidden Archive', status: :active, featured: false)
        pub_article = create(:help_center_article, account: account, portal: portal, primary_category: featured_cat, title: 'Quick Start', status: :published)
        draft_article = create(:help_center_article, account: account, portal: portal, primary_category: featured_cat, title: 'Draft Notes', status: :draft)

        get root_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(featured_cat.name)
        expect(response.body).not_to include(unfeatured_cat.name)
        expect(response.body).to include(pub_article.title)
        expect(response.body).not_to include(draft_article.title)
      end
    end

    it 'renders the web widget script when show_web_widget flag is enabled' do
      account.with_shard do
        widget = create(:channel_web_widget, account: account)
        portal.update!(flags: 4, web_widget_channel: widget) # flag 3: show_web_widget (bit 4)

        get root_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('embed.js')
      end
    end

    it 'supports localized portal urls' do
      get '/es'

      expect(response).to have_http_status(:ok)
    end

    it 'redirects to default locale path when an unsupported 2-letter locale is requested' do
      get '/de'

      expect(response).to have_http_status(:moved_permanently)
    end
  end

  context 'when domain does not resolve to an active portal' do
    it 'returns 404 not found' do
      host! 'unknown.example.com'
      get '/'

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 when domain status is inactive' do
      domain.update!(status: :inactive)

      get root_path
      expect(response).to have_http_status(:not_found)
    end
  end
end
