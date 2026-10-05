# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contact Support Feature', type: :feature do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:contact_form) do
    account.with_shard do
      form = create(:channel_contact_form, account: account, spam_protection_enabled: true, allow_attachments: true)
      create(:inbox, account: account, channel: form, primary_inbox: true)
      custom_field = account.custom_fields.find_by(key: 'subject') || create(:custom_field, account: account, key: 'subject', label: 'Subject', field_type: :text)
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
        name: 'Deskbolic Support',
        status: :active,
        show_contact_form: true,
        contact_form_channel: contact_form
      )
    end
  end

  before do
    set_tenant_host(domain)
  end

  describe 'Contact Form Page' do
    it 'allows visitors to submit a request and shows the success screen with ticket ID' do
      account.with_shard do
        article = create(:help_center_article, account: account, portal: portal, title: 'Troubleshooting Guide', status: :published)

        mock_conv = double('Conversation', identifier: 'REQ-88990')
        allow(Channels::ContactForms::ConversationCreator).to receive(:call).and_return(mock_conv)

        visit contact_path

        expect(page).to have_text('Submit a Request')
        expect(page).to have_field('contact_subject')

        fill_in 'contact_subject', with: 'Payment failed for subscription'
        click_button 'Submit Request'

        # Redirected to success page
        expect(page).to have_text('Your request has been submitted')
        expect(page).to have_text('#REQ-88990')
        expect(page).to have_text('While you wait...')
        expect(page).to have_text('Troubleshooting Guide')
      end
    end

    it 'silently traps bots when hidden honeypot field is filled' do
      expect(Channels::ContactForms::ConversationCreator).not_to receive(:call)

      visit contact_path
      fill_in 'gift_vcode', with: 'bot_value', visible: :hidden
      fill_in 'contact_subject', with: 'Spam offer'
      click_button 'Submit Request'

      expect(page).to have_text('Your request has been submitted')
    end

    it 'redirects to contact form when success page is visited directly' do
      visit contact_success_path

      expect(page).to have_current_path(contact_path, ignore_query: true)
    end

    it 'redirects to portal home when contact form is disabled on portal' do
      account.with_shard do
        portal.update!(show_contact_form: false)

        visit contact_path
        expect(page).to have_current_path(root_path, ignore_query: true)
      end
    end

    it 'shows unconfigured message when form has no custom fields' do
      account.with_shard do
        contact_form.custom_field_resources.destroy_all

        visit contact_path
        expect(page).to have_text('This form is not yet configured. Please try again later.')
      end
    end
  end
end
