# frozen_string_literal: true

module HelpCenter
  class TenantResolver
    def self.resolve(request)
      host = request.host
      domain = Domain.find_by(value: host, status: :active)
      return nil unless domain

      # Only serve portals on verified domains (subdomains are always verified)
      return nil unless domain.dns_verified? || domain.subdomain?

      portal = HelpCenter::Portal.with_attached_logo.with_attached_favicon.with_attached_social_share_image.with_attached_hero_image.includes(:translations, :web_widget_channel).find_by(domain_id: domain.id, status: :active)
      return nil unless portal

      {
        account: domain.account,
        portal: portal,
        domain: domain
      }
    end
  end
end
