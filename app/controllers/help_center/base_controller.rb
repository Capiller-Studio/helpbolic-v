# frozen_string_literal: true

module HelpCenter
  class BaseController < ApplicationController
    include Pagy::Backend
    helper HelpCenter::ApplicationHelper
    helper HelpCenter::MetaTagsHelper
    helper HelpCenter::ImageHelper
    helper HelpCenter::ReadTimeHelper
    before_action :resolve_tenant!
    skip_around_action :switch_locale, raise: false
    around_action :switch_locale
    around_action :set_sharding_context

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
      if @current_account
        @current_account.with_shard(&block)
      else
        yield
      end
    end

    def switch_locale(&action)
      requested_locale = params[:locale]&.to_s
      
      locale_to_set = if requested_locale.blank?
        current_portal.default_locale
      elsif current_portal.locales.include?(requested_locale)
        requested_locale
      else
        nil
      end

      if locale_to_set
        I18n.with_locale(locale_to_set, &action)
      else
        redirect_to url_for(params.to_unsafe_h.merge(locale: nil, only_path: true)), status: :moved_permanently
      end
    end

    # TODO; After proper errors-controller implementation we won't need this, check techbolic-solutions ErrorsController.
    def render_not_found
      render plain: "404 Not Found", status: :not_found
    end

    def default_url_options
      if I18n.locale.to_s != current_portal.default_locale.to_s
        { locale: I18n.locale }
      else
        { locale: nil }
      end
    end
  end
end
