# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Internal::DomainChecks', type: :request do
  let(:account) { create(:account) }

  describe 'GET /internal/domain_check' do
    it 'returns 200 OK when domain exists' do
      create(:domain, :custom, :dns_verified, account: account, value: 'docs.example.com', status: :active)

      get internal_domain_check_path, params: { domain: 'docs.example.com' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('OK')
    end

    it 'returns 404 when domain does not exist' do
      get internal_domain_check_path, params: { domain: 'notfound.example.com' }

      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq('Domain not found')
    end

    it 'returns 400 bad request when domain parameter is missing' do
      get internal_domain_check_path

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq('Missing domain')
    end
  end
end
