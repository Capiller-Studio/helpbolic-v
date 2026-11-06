# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Marketing Landing Page Feature', type: :feature do
  before do
    set_marketing_host
  end

  describe 'Root Marketing Domain (helpbolic.com)' do
    it 'renders navigation, hero section, CTA buttons, and footer' do
      visit root_path

      expect(page.status_code).to eq(200)

      # Navigation
      expect(page).to have_link('Features', href: 'https://deskbolic.com/#our-features-section')
      expect(page).to have_link('Pricing', href: 'https://deskbolic.com/pricing')
      expect(page).to have_link('Help Center', href: 'https://deskbolic.com/help-center')
      expect(page).to have_link('Log in', href: 'https://deskbolic.app/login')
      expect(page).to have_link('Get Started', href: 'https://deskbolic.app/register')

      # Hero Section
      expect(page).to have_text('Capiller Rely Help')
      expect(page).to have_text('Deliver exceptional customer support')
      expect(page).to have_text('Deliver seamless customer self-service')

      # Call to Actions
      expect(page).to have_link('Create Your Help Center', href: 'https://deskbolic.app/register')
      expect(page).to have_link('Explore Features', href: 'https://deskbolic.com/help-center')

      # Footer
      expect(page).to have_text("© #{Time.current.year} TECHBOLIC, LLC. All rights reserved.")
      expect(page).to have_button('Cookie Settings')
    end

    it 'renders canonical link, favicons, meta tags, and structured data in head' do
      visit root_path

      html = page.html

      # Canonical link
      expect(html).to include('rel="canonical"')

      # Favicons
      expect(html).to include('fav_icon')
      expect(html).to include('rel="icon"')
      expect(html).to include('rel="apple-touch-icon"')

      # OpenGraph & Twitter
      expect(html).to include('property="og:site_name"')
      expect(html).to include('name="twitter:card"')

      # Structured Data Schema.org
      expect(html).to include('application/ld+json')
      expect(html).to include('"@type":"Organization"')
      expect(html).to include('TECHBOLIC, LLC')
      expect(html).to include('"@type":"WebSite"')
      expect(html).to include('"@type":"SoftwareApplication"')
    end
  end
end
