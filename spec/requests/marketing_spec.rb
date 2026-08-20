# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Marketing', type: :request do
  describe 'GET / on base marketing domain' do
    it 'renders the marketing landing page on helpbolic.com' do
      set_marketing_host
      get '/'

      expect(response).to have_http_status(:ok)
    end
  end
end
