# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::Contacts', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:contact_form) do
    account.with_shard do
      form = create(:channel_contact_form, account: account, spam_protection_enabled: true, allow_attachments: true)
      create(:inbox, account: account, channel: form, primary_inbox: true)
      custom_field = account.custom_fields.find_by(key: 'subject') || create(:custom_field, account: account)
      create(:custom_field_resource, custom_field: custom_field, resource: form)
      form
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
        contact_form_channel: contact_form
      )
    end
  end

  before do
    set_tenant_host(domain)
  end

  describe 'GET /contact' do
    it 'renders the contact form page when contact form is enabled and configured' do
      get contact_path

      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root when contact form is disabled on portal' do
      account.with_shard do
        portal.update!(show_contact_form: false)
      end

      get contact_path

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root when require_login is enabled on form and customer is not logged in' do
      account.with_shard do
        contact_form.update!(require_login: true)
      end

      get contact_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t('help_center.contact.new.login_required', default: 'Please sign in to submit this form.'))
    end
  end

  describe 'POST /contact' do
    it 'creates a conversation ticket successfully and redirects to success' do
      mock_conv = double('Conversation', identifier: 'TCK-12345')
      allow(Channels::ContactForms::ConversationCreator).to receive(:call).and_return(mock_conv)

      post contact_path, params: {
        contact: { subject: 'Need Help with Setup' }
      }

      expect(response).to redirect_to(contact_success_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('TCK-12345')
    end

    it 'accepts valid PDF or image file attachments' do
      mock_conv = double('Conversation', identifier: 'TCK-99999')
      file = fixture_file_upload(Rails.public_path.join('icon.png'), 'image/png')
      allow(Channels::ContactForms::ConversationCreator).to receive(:call).and_return(mock_conv)

      post contact_path, params: {
        contact: { subject: 'With Attachment' },
        attachments: [ file ]
      }

      expect(response).to redirect_to(contact_success_path)
    end

    it 'rejects disallowed attachment file types' do
      invalid_file = fixture_file_upload(Rails.root.join('Gemfile'), 'text/plain')

      post contact_path, params: {
        contact: { subject: 'Invalid file upload' },
        attachments: [ invalid_file ]
      }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'silently traps bots when honeypot field :nickname is filled' do
      expect(Channels::ContactForms::ConversationCreator).not_to receive(:call)

      post contact_path, params: {
        nickname: 'spam_bot_input',
        contact: { subject: 'Spam Message' }
      }

      expect(response).to redirect_to(contact_success_path)
    end

    it 'renders unprocessable_content on error' do
      allow(Channels::ContactForms::ConversationCreator).to receive(:call).and_raise(StandardError.new('Validation failed'))

      post contact_path, params: {
        contact: { subject: 'Invalid' }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'GET /contact/success' do
    it 'redirects back to contact form if visited directly without flash' do
      get contact_success_path

      expect(response).to redirect_to(contact_path)
    end
  end
end
