# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :request do
  describe 'GET /404' do
    it 'renders 404 error template with noindex, nofollow' do
      get '/404'

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('name="robots"').and include('noindex, nofollow')
    end
  end

  describe 'GET /422' do
    it 'renders 422 error template with noindex, nofollow' do
      get '/422'

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('name="robots"').and include('noindex, nofollow')
    end
  end

  describe 'GET /500' do
    it 'renders 500 error template with noindex, nofollow' do
      get '/500'

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include('name="robots"').and include('noindex, nofollow')
    end
  end
end
