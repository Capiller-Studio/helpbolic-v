# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Marketing', type: :request do
  describe 'GET / on base marketing domain' do
    it 'renders the marketing landing page on helpbolic.com with SEO meta tags, favicons, and structured data' do
      set_marketing_host
      get '/'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('rel="canonical"')
      expect(response.body).to include('fav_icon')
      expect(response.body).to include('application/ld+json')
      expect(response.body).to include('TECHBOLIC, LLC')
      expect(response.body).to include('property="og:title"')
      expect(response.body).to include('name="twitter:card"')
      expect(response.body).to include('Deliver seamless customer self-service')
    end
  end
end
