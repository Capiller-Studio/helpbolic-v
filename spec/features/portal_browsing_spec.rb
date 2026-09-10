# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Help Center Portal Browsing Feature', type: :feature do
  describe 'Marketing landing page' do
    it 'loads the marketing homepage' do
      set_marketing_host
      visit root_path

      expect(page.status_code).to eq(200)
    end
  end

  describe 'Customer Help Center Portal' do
    let(:account) { create(:account) }
    let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'help.lvh.me', status: :active) }
    let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active, default_locale: 'en', locales: %w[en es]) }

    before do
      set_tenant_host(domain)
    end

    it 'allows visitors to view featured categories and read published articles' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Billing & Subscriptions', status: :active, featured: true)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'How to update your credit card', content: 'Step 1: Go to billing settings. Step 2: Click update card.', status: :published)

        visit root_path

        expect(page).to have_content('Billing & Subscriptions')
        expect(page).to have_content('How to update your credit card')

        # Visit the article page
        click_link 'How to update your credit card'

        expect(page).to have_content('How to update your credit card')
        expect(page).to have_content('Step 1: Go to billing settings.')
      end
    end
  end
end
