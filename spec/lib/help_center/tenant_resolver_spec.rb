# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::TenantResolver do
  let(:account) { create(:account) }

  describe '.resolve' do
    let(:request) { double('Request', host: 'docs.example.com') }

    context 'when domain exists as custom domain and is verified with active portal' do
      let!(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'docs.example.com', status: :active) }
      let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

      it 'resolves account, portal, and domain' do
        result = described_class.resolve(request)

        expect(result).to be_present
        expect(result[:account]).to eq(account)
        expect(result[:portal]).to eq(portal)
        expect(result[:domain]).to eq(domain)
      end
    end

    context 'when domain is a subdomain (auto-verified)' do
      let!(:domain) { create(:domain, :subdomain, account: account, value: 'mybrand', status: :active) }
      let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }
      let(:subdomain_request) { double('Request', host: 'mybrand.helpbolic.com') }

      it 'resolves the tenant successfully' do
        result = described_class.resolve(subdomain_request)

        expect(result).to be_present
        expect(result[:portal]).to eq(portal)
      end
    end

    context 'when custom domain is dns_unverified' do
      let!(:domain) { create(:domain, :custom, :dns_unverified, account: account, value: 'docs.example.com', status: :active) }
      let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

      it 'returns nil' do
        expect(described_class.resolve(request)).to be_nil
      end
    end

    context 'when domain exists but has no attached portal' do
      let!(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'docs.example.com', status: :active) }

      it 'returns nil' do
        expect(described_class.resolve(request)).to be_nil
      end
    end

    context 'when domain is inactive' do
      let!(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'docs.example.com', status: :inactive) }
      let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

      it 'returns nil' do
        expect(described_class.resolve(request)).to be_nil
      end
    end

    context 'when domain does not exist' do
      it 'returns nil' do
        expect(described_class.resolve(request)).to be_nil
      end
    end
  end
end
