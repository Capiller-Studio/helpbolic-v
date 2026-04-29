# frozen_string_literal: true

module HelpCenter
  class BaseController < ApplicationController
    before_action :resolve_tenant!
    around_action :set_sharding_context
    before_action :set_locale

    attr_reader :current_account, :current_portal

    private

    def resolve_tenant!
      tenant = TenantResolver.resolve(request)
      if tenant
        @current_account = tenant[:account]
        @current_portal = tenant[:portal]
      else
        render_not_found
      end
    end

    def set_sharding_context(&block)
      # Assuming Account uses sharding. We need to find which shard the account belongs to.
      # For now, we'll use the primary or handle it via a helper if core provides one.
      # ActiveRecord::Base.connected_to(role: :reading, shard: current_account.shard) do
      #   yield
      # end
      yield
    end

    def set_locale
      # Priority: 1. URL param, 2. Portal default
      locale = params[:locale] || current_portal.default_locale
      I18n.locale = current_portal.locales.include?(locale) ? locale : current_portal.default_locale
    end

    def render_not_found
      render plain: "404 Not Found", status: :not_found
    end

    def default_url_options
      { locale: I18n.locale }
    end
  end
end
