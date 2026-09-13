# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Portal Customization Feature', type: :feature do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'custom.lvh.me', status: :active) }

  before do
    set_tenant_host(domain)
  end

  describe 'Theme and CSS Customization' do
    it 'applies dynamic primary/secondary colors, custom font family, and custom CSS in the DOM' do
      account.with_shard do
        portal = create(
          :help_center_portal,
          account: account,
          domain: domain,
          name: 'Custom Brand Portal',
          status: :active,
          ui_configurations: {
            'primary_color' => '#FF5500',
            'secondary_color' => '#002244',
            'font_family' => 'Poppins, sans-serif',
            'theme_mode' => 'dark'
          },
          configurations: {
            'custom_css' => '.vip-banner { background: gold !important; }'
          }
        )

        visit root_path

        # Theme mode on html tag
        expect(page).to have_css('html[data-theme="dark"]')

        # Dynamic root styles & custom css
        html = page.html
        expect(html).to include('--color-primary: #FF5500')
        expect(html).to include('--color-secondary: #002244')
        expect(html).to include('--font-family: Poppins, sans-serif')
        expect(html).to include('.vip-banner { background: gold !important; }')
      end
    end

    it 'renders hero gradient background when hero_style is gradient' do
      account.with_shard do
        create(
          :help_center_portal,
          account: account,
          domain: domain,
          name: 'Gradient Portal',
          status: :active,
          ui_configurations: {
            'hero_style' => 'gradient'
          }
        )

        visit root_path

        expect(page).to have_css('.hero-bg.gradient-bg')
      end
    end

    it 'renders fallback svg brand icon when portal logo is not attached' do
      account.with_shard do
        create(
          :help_center_portal,
          account: account,
          domain: domain,
          name: 'SVG Brand Portal',
          status: :active
        )

        visit root_path

        expect(page).to have_css('nav.navbar .navbar-logo svg')
      end
    end
  end
end
