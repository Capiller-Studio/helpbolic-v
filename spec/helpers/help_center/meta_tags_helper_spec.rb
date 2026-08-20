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
end
