# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SEO and Metadata Feature', type: :feature do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'kb.example.com', status: :active) }
  let!(:portal) do
    account.with_shard do
      create(
        :help_center_portal,
        account: account,
        domain: domain,
        name: 'Acme Knowledge Base',
        hero_subtitle: 'All Acme help articles in one place',
        status: :active,
        flags: 8, # indexing_enabled
        default_locale: 'en',
        locales: %w[en es]
      )
    end
  end

  before do
    set_tenant_host(domain)
  end

  describe 'Portal Homepage SEO' do
    it 'renders complete meta tags, canonical link, social cards, and Schema.org WebSite schema' do
      visit root_path

      expect(page).to have_title('Acme Knowledge Base')
      expect(page).to have_css("meta[name='description'][content='All Acme help articles in one place']", visible: :hidden)
      expect(page).to have_css("link[rel='canonical']", visible: :hidden)
      expect(page).to have_css("meta[name='robots'][content='index, follow']", visible: :hidden)

      # OpenGraph
      expect(page).to have_css("meta[property='og:site_name'][content='Acme Knowledge Base']", visible: :hidden)
      expect(page).to have_css("meta[property='og:title'][content='Acme Knowledge Base']", visible: :hidden)
      expect(page).to have_css("meta[property='og:type'][content='website']", visible: :hidden)

      # Twitter Card
      expect(page).to have_css("meta[name='twitter:card'][content='summary_large_image']", visible: :hidden)
      expect(page).to have_css("meta[name='twitter:title'][content='Acme Knowledge Base']", visible: :hidden)

      # Favicons
      expect(page).to have_css("link[rel='icon']", visible: :hidden)
      expect(page).to have_css("link[rel='apple-touch-icon']", visible: :hidden)

      # Structured Data
      expect(page.html).to include('application/ld+json')
      expect(page.html).to include('"@type":"WebSite"')
      expect(page.html).to include('"name":"Acme Knowledge Base"')
    end

    it 'renders noindex, nofollow when portal indexing is disabled' do
      account.with_shard do
        portal.update!(flags: 0) # disable indexing_enabled

        visit root_path
        expect(page).to have_css("meta[name='robots'][content='noindex, nofollow']", visible: :hidden)
      end
    end

    it 'renders hreflang links for multilingual portals' do
      visit root_path

      expect(page).to have_css("link[rel='alternate'][hreflang='en']", visible: :hidden)
      expect(page).to have_css("link[rel='alternate'][hreflang='es']", visible: :hidden)
    end
  end

  describe 'Category Page SEO' do
    it 'renders dynamic title, description, canonical, and Schema.org CollectionPage + Breadcrumbs' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Billing FAQ', description: 'Everything about invoices and receipts', status: :active)

        visit category_path(id: category.id)

        expect(page).to have_title('Billing FAQ - Acme Knowledge Base')
        expect(page).to have_css("meta[name='description'][content='Everything about invoices and receipts']", visible: :hidden)
        expect(page).to have_css("link[rel='canonical']", visible: :hidden)

        # Structured Data
        expect(page.html).to include('application/ld+json')
        expect(page.html).to include('"@type":"CollectionPage"')
        expect(page.html).to include('"@type":"BreadcrumbList"')
        expect(page.html).to include('"name":"Home"')
        expect(page.html).to include('"name":"Billing FAQ"')
      end
    end
  end

  describe 'Article Page SEO' do
    it 'renders dynamic title, article description, og:type article, and Schema.org Article + Breadcrumbs' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Setup', status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'Installing the Extension', content: 'Step by step guide to install the extension successfully.', status: :published)

        visit article_path(id: article.id)

        expect(page).to have_title('Installing the Extension - Acme Knowledge Base')
        expect(page).to have_css("meta[name='description']", visible: :hidden)
        expect(page).to have_css("link[rel='canonical']", visible: :hidden)
        expect(page).to have_css("meta[property='og:type'][content='article']", visible: :hidden)

        # Structured Data
        expect(page.html).to include('application/ld+json')
        expect(page.html).to include('"@type":"Article"')
        expect(page.html).to include('"headline":"Installing the Extension"')
        expect(page.html).to include('"@type":"BreadcrumbList"')
        expect(page.html).to include('"name":"Home"')
        expect(page.html).to include('"name":"Setup"')
        expect(page.html).to include('"name":"Installing the Extension"')
      end
    end
  end
end
