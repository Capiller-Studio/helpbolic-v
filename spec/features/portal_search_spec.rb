# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Portal Search Feature', type: :feature do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'help.lvh.me', status: :active) }
  let!(:portal) do
    account.with_shard do
      create(
        :help_center_portal,
        account: account,
        domain: domain,
        name: 'Capiller Rely Help Center',
        status: :active,
        default_locale: 'en',
        locales: %w[en es]
      )
    end
  end

  before do
    set_tenant_host(domain)
  end

  describe 'Full Search Page' do
    it 'displays default articles when query is blank' do
      account.with_shard do
        cat = create(:help_center_category, account: account, portal: portal, name: 'Billing', status: :active)
        art = create(:help_center_article, account: account, portal: portal, primary_category: cat, title: 'Invoicing 101', status: :published)
        cat.articles << art

        visit search_path

        expect(page).to have_title(/Search Results/)
        expect(page).to have_text('Showing 1 result')
        expect(page).to have_text('Invoicing 101')
      end
    end

    it 'renders articles search results and allows switching to categories tab' do
      account.with_shard do
        cat = create(:help_center_category, account: account, portal: portal, name: 'Billing and Plans', status: :active)
        art = create(:help_center_article, account: account, portal: portal, primary_category: cat, title: 'How to pay invoices', content: 'Use your credit card', status: :published)
        cat.articles << art

        articles_search = double('SearchkickArticles', total_count: 1, to_a: [ art ], empty?: false, any?: true)
        allow(articles_search).to receive(:each).and_yield(art)

        categories_search = double('SearchkickCategories', total_count: 1, size: 1, to_a: [ cat ], empty?: false, any?: true)
        allow(categories_search).to receive(:each).and_yield(cat)

        allow(HelpCenter::Article).to receive(:search).and_return(articles_search)
        allow(HelpCenter::Category).to receive(:search).and_return(categories_search)

        visit search_path(query: 'billing')

        # Articles tab active by default
        expect(page).to have_text('How to pay invoices')
        expect(page).to have_text('Showing 1 result for "billing"')

        # Switch to categories tab
        click_link 'Categories'
        expect(page).to have_text('Billing and Plans')
      end
    end

    it 'shows empty state with browse categories button when no results match' do
      empty_mock = double('EmptySearch', total_count: 0, size: 0, to_a: [], each: [].each, empty?: true, any?: false)
      allow(HelpCenter::Article).to receive(:search).and_return(empty_mock)
      allow(HelpCenter::Category).to receive(:search).and_return(empty_mock)

      visit search_path(query: 'nonexistentkeyword123')

      expect(page).to have_text('No results found for "nonexistentkeyword123"')
      expect(page).to have_text('Try adjusting your search or browse our categories.')
      expect(page).to have_link('Browse Categories')

      click_link 'Browse Categories'
      expect(page).to have_text('Capiller Rely Help Center')
    end
  end
end
