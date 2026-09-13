# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::MetaTagsHelper, type: :helper do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let(:portal) { create(:help_center_portal, account: account, domain: domain, name: 'Acme Help Center', hero_subtitle: 'Acme Knowledge Base') }

  before do
    @current_portal = portal
  end

  describe '#meta_title' do
    it 'returns content_for(:meta_title) when set' do
      helper.content_for(:meta_title, 'Custom Title')
      expect(helper.meta_title).to eq('Custom Title')
    end

    it 'falls back to current portal name when not set' do
      expect(helper.meta_title).to eq('Acme Help Center')
    end

    it 'falls back to default when portal is nil' do
      @current_portal = nil
      expect(helper.meta_title).to eq('Help Center')
    end
  end

  describe '#meta_description' do
    it 'returns content_for(:meta_description) when set' do
      helper.content_for(:meta_description, 'Custom Description')
      expect(helper.meta_description).to eq('Custom Description')
    end

    it 'falls back to portal description/hero_subtitle' do
      expect(helper.meta_description).to eq('Acme Knowledge Base')
    end

    it 'falls back to default when portal is nil' do
      @current_portal = nil
      expect(helper.meta_description).to eq('Help Center')
    end
  end

  describe '#meta_keywords' do
    it 'returns content_for(:meta_keywords) when set' do
      helper.content_for(:meta_keywords, 'docs, guide, billing')
      expect(helper.meta_keywords).to eq('docs, guide, billing')
    end

    it 'falls back to default keywords' do
      expect(helper.meta_keywords).to eq('help center, support, faq')
    end
  end

  describe '#meta_image' do
    it 'returns content_for(:meta_image) when set with an absolute URL' do
      helper.content_for(:meta_image, 'https://cdn.example.com/og.png')
      expect(helper.meta_image).to eq('https://cdn.example.com/og.png')
    end

    it 'returns nil when no meta image is set' do
      expect(helper.meta_image).to be_nil
    end
  end

  describe '#set_meta_tags' do
    it 'sets title, meta_title, meta_description, keywords, image, and og_type' do
      helper.set_meta_tags(
        title: 'Billing FAQs',
        description: 'Common billing answers',
        keywords: 'billing, invoices',
        image: 'https://cdn.example.com/banner.png',
        type: 'article'
      )

      expect(helper.meta_title).to eq('Billing FAQs')
      expect(helper.meta_description).to eq('Common billing answers')
      expect(helper.meta_keywords).to eq('billing, invoices')
      expect(helper.meta_image).to eq('https://cdn.example.com/banner.png')
      expect(helper.meta_og_type).to eq('article')
    end
  end

  describe '#meta_og_type' do
    it 'defaults to website' do
      expect(helper.meta_og_type).to eq('website')
    end

    it 'returns content_for(:og_type) when set' do
      helper.content_for(:og_type, 'article')
      expect(helper.meta_og_type).to eq('article')
    end
  end

  describe '#portal_favicon_url' do
    it 'falls back to fav_icon.png when no custom favicon attached' do
      expect(helper.portal_favicon_url).to include('fav_icon')
    end
  end

  describe '#canonical_url' do
    it 'generates a canonical URL for current portal' do
      expect(helper.canonical_url).to be_present
    end
  end

  describe '#hreflang_links' do
    it 'returns empty array when portal has single locale' do
      portal.update!(locales: [ 'en' ])
      expect(helper.hreflang_links).to eq([])
    end

    it 'returns alternate links for multiple locales' do
      portal.update!(locales: %w[en es fr])
      links = helper.hreflang_links
      expect(links.size).to eq(3)
      expect(links.pluck(:locale)).to contain_exactly('en', 'es', 'fr')
    end
  end

  describe '#robots_content' do
    it 'returns index, follow when portal indexing is enabled' do
      portal.update!(flags: 8) # indexing_enabled is bit 8 (flag 4)
      expect(helper.robots_content).to eq('index, follow')
    end

    it 'returns noindex, nofollow when portal indexing is disabled' do
      portal.update!(flags: 0)
      expect(helper.robots_content).to eq('noindex, nofollow')
    end

    it 'returns content_for(:robots) if explicitly set' do
      helper.content_for(:robots, 'noarchive')
      expect(helper.robots_content).to eq('noarchive')
    end
  end
end
