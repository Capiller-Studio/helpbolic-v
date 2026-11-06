# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Portal Localization Feature', type: :feature do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'docs.lvh.me', status: :active) }
  let!(:portal) do
    account.with_shard do
      create(
        :help_center_portal,
        account: account,
        domain: domain,
        name: 'Capiller Rely Help Portal',
        default_locale: 'en',
        locales: %w[en es fr],
        status: :active
      )
    end
  end

  before do
    set_tenant_host(domain)
  end

  describe 'Multi-locale switching and routing' do
    it 'renders language switcher when portal supports multiple locales' do
      visit root_path

      expect(page).to have_css('.locale-selector select')
    end

    it 'renders translated content when visiting localized URL' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Billing', status: :active, featured: true)
        category.translations.create!(locale: 'es', name: 'Facturación', slug: 'facturacion')

        visit '/es'

        expect(page).to have_text('Facturación')
      end
    end

    it 'redirects unsupported locales to default locale' do
      visit '/de'

      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'displays localized articles and categories when requested with locale prefix' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, name: 'Security', status: :active)
        category.translations.create!(locale: 'fr', name: 'Sécurité', slug: 'securite')

        article = create(:help_center_article, account: account, portal: portal, primary_category: category, title: '2FA Guide', status: :published)
        article.translations.create!(locale: 'fr', title: 'Guide 2FA', content: 'Activer 2FA', slug: 'guide-2fa')

        visit "/fr/articles/#{article.id}"

        expect(page).to have_text('Guide 2FA')
        expect(page).to have_text('Activer 2FA')
      end
    end
  end
end
