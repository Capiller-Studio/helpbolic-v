# frozen_string_literal: true

module HelpCenter
  class PortalsController < BaseController
    def show
      @categories = current_portal.categories.active.featured.order(position: :asc).includes(:translations).with_attached_image

      @popular_articles = current_portal.articles.published.where(visibility: :everyone).order(views_count: :desc).limit(4).includes(:translations)
    end
  end
end
