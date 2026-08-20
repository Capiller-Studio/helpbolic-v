# frozen_string_literal: true

class ErrorsController < ApplicationController
  layout :resolve_layout

  def not_found
    render_error(404)
  end

  def invalid_resource
    render_error(422)
  end

  def internal_server_error
    render_error(500)
  end

  private

  def resolve_layout
    @current_portal.present? ? "application" : "marketing"
  end

  def render_error(status)
    # We try to resolve the tenant even on error pages to keep the branding
    @tenant = HelpCenter::TenantResolver.resolve(request)
    @current_portal = @tenant[:portal] if @tenant

    render(template: "errors/error_#{status}", status: status, layout: resolve_layout)
  end
end
