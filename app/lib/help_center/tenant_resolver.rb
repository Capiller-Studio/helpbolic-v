# frozen_string_literal: true

module HelpCenter
  class TenantResolver
    def self.resolve(request)
      host = request.host
      domain = Domain.find_by(value: host, status: :active)
      return nil unless domain

      portal = HelpCenter::Portal.find_by(domain_id: domain.id, status: :active)
      return nil unless portal

      {
        account: domain.account,
        portal: portal
      }
    end
  end
end
