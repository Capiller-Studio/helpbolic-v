# frozen_string_literal: true

module Internal
  class DomainChecksController < ApplicationController
    def show
      domain = params[:domain]

      if domain.blank?
        return render plain: "Missing domain", status: :bad_request
      end

      # Proxy server sends a GET request here with ?domain=example.com.
      # If we return a 200 OK, issue the SSL certificate.
      # If we return 404 or 400,  will reject the SSL request to prevent abuse.
      # Check if any tenant has this domain (either custom domain or helpbolic subdomain).
      if Domain.exists?(value: domain)
        render plain: "OK", status: :ok
      else
        render plain: "Domain not found", status: :not_found
      end
    end
  end
end
