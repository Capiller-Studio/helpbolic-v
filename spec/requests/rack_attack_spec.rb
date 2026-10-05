# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rack::Attack Rate Limiting in Helpbolic', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:form) do
    account.with_shard do
      f = create(:channel_contact_form, account: account)
      create(:inbox, account: account, channel: f, primary_inbox: true)
      custom_field = account.custom_fields.find_by(key: 'subject') || create(:custom_field, account: account)
      create(:custom_field_resource, custom_field: custom_field, resource: f)
      f
    end
  end
  let!(:portal) do
    account.with_shard do
      create(
        :help_center_portal,
        account: account,
        domain: domain,
        status: :active,
        show_contact_form: true,
        contact_form_channel: form
      )
    end
  end

  before do
    host! domain.value
  end

  around do |example|
    original_store = Rack::Attack.cache.store
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.enabled = true
    Rack::Attack.reset!
    example.run
  ensure
    Rack::Attack.enabled = false
    Rack::Attack.reset!
    Rack::Attack.cache.store = original_store
  end

  describe 'POST /contact (contact form throttling)' do
    it 'throttles submissions by IP after 5 attempts' do
      5.times do
        post contact_path, params: {
          contact: { subject: 'Question', email: 'user@example.com' }
        }
        expect(response.status).not_to eq(429)
      end

      post contact_path, params: {
        contact: { subject: 'Question', email: 'user@example.com' }
      }
      expect(response.status).to eq(429)
    end
  end
end
