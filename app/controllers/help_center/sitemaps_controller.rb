# frozen_string_literal: true

module HelpCenter
  class SitemapsController < BaseController
    layout false

    def index
      # Respect portal's indexing preference
      if current_portal.indexing_enabled?
        @categories = current_portal.categories.where(visibility: :everyone).active
        @articles = current_portal.articles.where(visibility: :everyone).published
      else
        @categories = []
        @articles = []
      end

      respond_to do |format|
        format.xml
      end
    end
  end
end
