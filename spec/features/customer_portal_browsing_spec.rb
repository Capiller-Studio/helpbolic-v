# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Customer Portal Browsing Feature', type: :feature do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'help.lvh.me', status: :active) }
  let!(:portal) do
    account.with_shard do
      create(
        :help_center_portal,
        account: account,
        domain: domain,
        name: 'Deskbolic Help Center',
        hero_title: 'How can we help you?',
        hero_subtitle: 'Search our knowledge base or browse categories below',
        status: :active,
        default_locale: 'en',
        locales: %w[en es]
      )
    end
  end

  before do
    set_tenant_host(domain)
  end

  describe 'Portal Homepage' do
    it 'displays the portal branding, hero section, featured categories, and popular articles' do
      account.with_shard do
        featured_cat = create(:help_center_category, account: account, portal: portal, name: 'Getting Started', status: :active, featured: true)
        unfeatured_cat = create(:help_center_category, account: account, portal: portal, name: 'Internal Wiki', status: :active, featured: false)
        article = create(:help_center_article, account: account, portal: portal, primary_category: featured_cat, title: 'Quick Start Guide', status: :published, views_count: 50)
        featured_cat.articles << article

        visit root_path

        # Portal header & branding
        expect(page).to have_text('Deskbolic Help Center')
        expect(page).to have_text('How can we help you?')
        expect(page).to have_text('Search our knowledge base or browse categories below')

        # Categories
        expect(page).to have_text('Getting Started')
        expect(page).to have_no_text('Internal Wiki')

        # Popular articles
        expect(page).to have_text('Popular Articles')
        expect(page).to have_text('Quick Start Guide')

        # Need more help section
        expect(page).to have_text('Need more help?')
        expect(page).to have_text('Contact Support')
      end
    end
  end

  describe 'Category Page Navigation' do
    it 'allows visitors to view category details, subcategories, and sibling categories' do
      account.with_shard do
        parent = create(:help_center_category, account: account, portal: portal, name: 'Account & Billing', description: 'Manage your subscription and invoices', status: :active, featured: true)
        subcat = create(:help_center_category, account: account, portal: portal, name: 'Invoices', description: 'Download past invoices', parent: parent, status: :active)
        sibling = create(:help_center_category, account: account, portal: portal, name: 'Security', status: :active, featured: true)
        article = create(:help_center_article, account: account, portal: portal, primary_category: parent, title: 'How to update billing details', status: :published)
        parent.articles << article

        visit category_path(id: parent.id)

        # Breadcrumbs
        expect(page).to have_text('Home')
        expect(page).to have_text('Account & Billing')
        expect(page).to have_text('Manage your subscription and invoices')

        # Subcategories & articles
        expect(page).to have_text('Invoices')
        expect(page).to have_text('How to update billing details')

        # Sibling categories in sidebar
        expect(page).to have_text('Other Categories')
        expect(page).to have_text('Security')

        # Click subcategory
        click_link 'Invoices'
        expect(page).to have_text('Download past invoices')
      end
    end
  end

  describe 'Article Page & Interactions' do
    it 'allows visitors to read an article, view author and metadata, and submit helpfulness feedback' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Tutorials', status: :active, featured: true)
        author = create(:user, name: 'Sarah Connor')
        article = create(
          :help_center_article,
          account: account,
          portal: portal,
          primary_category: category,
          author: author,
          title: 'Setting up Webhooks',
          content: '<p>Here is how you set up webhooks in 3 easy steps.</p>',
          status: :published
        )
        category.articles << article

        visit article_path(id: article.id)

        # Breadcrumbs and title
        expect(page).to have_text('Home')
        expect(page).to have_text('Tutorials')
        expect(page).to have_text('Setting up Webhooks')

        # Content and author metadata
        expect(page).to have_text('Sarah Connor')
        expect(page).to have_text('Here is how you set up webhooks in 3 easy steps.')
        expect(page).to have_text('min read')

        # Feedback section
        expect(page).to have_text('Was this article helpful?')
        expect(page).to have_button('Yes')
        expect(page).to have_button('No')

        # Submit helpful reaction
        click_button 'Yes'
        expect(page).to have_text('Thanks for your feedback.')
      end
    end

    it 'renders sequential step navigation when category is in guide mode' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Onboarding Guide', status: :active, flags: 1) # guide_mode
        step1 = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'Step 1: Account Creation', position: 1, status: :published)
        step2 = create(:help_center_article, account: account, portal: portal, primary_category: category, title: 'Step 2: Team Invites', position: 2, status: :published)
        category.articles << step1
        category.articles << step2

        visit article_path(id: step1.id)

        expect(page).to have_text('Step 1: Account Creation')
        expect(page).to have_text('Next Step')
        expect(page).to have_text('Step 2: Team Invites')

        click_link 'Step 2: Team Invites'
        expect(page).to have_text('Previous Step')
        expect(page).to have_text('Step 1: Account Creation')
      end
    end

    it 'renders API endpoint documentation cards when article is api_endpoint type' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'API Reference', status: :active)
        api_article = create(
          :help_center_article,
          account: account,
          portal: portal,
          primary_category: category,
          title: 'Get User Profile',
          article_type: :api_endpoint,
          content: 'Returns user profile information.',
          status: :published,
          configurations: {
            'api_method' => 'GET',
            'api_endpoint' => '/v1/users/{id}',
            'api_parameters' => [
              { 'name' => 'id', 'type' => 'string', 'required' => true, 'description' => 'The unique user UUID' }
            ],
            'api_responses' => [
              { 'status' => 200, 'description' => 'Success', 'body' => '{"id": "usr_123"}' }
            ]
          }
        )

        visit article_path(id: api_article.id)

        expect(page).to have_text('GET')
        expect(page).to have_text('/v1/users/{id}')
        expect(page).to have_text('The unique user UUID')
        expect(page).to have_text('Success')
        expect(page).to have_text('{"id": "usr_123"}')
      end
    end
  end
end
