# frozen_string_literal: true

module HelpCenter
  class PortalsController < BaseController
    def show
      @categories = current_portal.categories.active.order(position: :asc)
    end
  end
end
