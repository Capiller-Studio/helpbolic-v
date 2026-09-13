# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::Articles', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

  before do
    set_tenant_host(domain)
  end

  describe 'GET /articles/:id' do
    it 'renders a published article and increments views count' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published, views_count: 5)

        expect do
          get article_path(id: article.id)
        end.to change { article.reload.views_count }.by(1)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(article.title)
      end
    end

    it 'renders SEO tags, canonical link, and JSON-LD schema on article page' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'How to Reset Password', content: 'Follow these steps to reset password.', status: :published)

        get article_path(id: article.id)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<title>#{article.title} - #{portal.name}</title>")
        expect(response.body).to include('rel="canonical"')
        expect(response.body).to include('property="og:type"')
        expect(response.body).to include('article')
        expect(response.body).to include('application/ld+json')
        expect(response.body).to include('"@type":"Article"')
        expect(response.body).to include('"@type":"BreadcrumbList"')
      end
    end

    it 'renders guide mode sequential navigation for guide categories' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active, flags: 1) # guide_mode
        article1 = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'Step 1: Install', position: 1, status: :published)
        article2 = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'Step 2: Configure', position: 2, status: :published)
        category.articles << article1
        category.articles << article2

        get article_path(id: article1.id)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(article1.title)
        expect(response.body).to include(article2.title)
      end
    end

    it 'redirects external link articles' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(
          :help_center_article,
          account: account,
          portal: portal,
          primary_category: category,
          status: :published,
          article_type: :external_link,
          configurations: { 'external_url' => 'https://external-docs.example.com' }
        )

        get article_path(id: article.id)

        expect(response).to redirect_to('https://external-docs.example.com')
      end
    end

    it 'returns 404 for draft articles' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :draft)

        get article_path(id: article.id)

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'returns 404 for archived articles' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :archived)

        get article_path(id: article.id)

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'returns 404 when article id does not exist' do
      get article_path(id: SecureRandom.uuid)

      expect(response).to have_http_status(:not_found)
    end
  end
end
