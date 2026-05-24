# frozen_string_literal: true

module HelpCenter
  class PortalsController < BaseController
    def show
      @categories = current_portal.categories.active.featured.order(position: :asc).includes(:translations).with_attached_image
      
      @category_article_counts = HelpCenter::CategoryResource
        .joins("INNER JOIN help_center_articles ON help_center_articles.id = help_center_category_resources.resource_id AND help_center_category_resources.resource_type = 'HelpCenter::Article'")
        .where(category_id: @categories.map(&:id))
        .where(help_center_articles: { status: HelpCenter::Article.statuses[:published] })
        .group(:category_id)
        .count

      @popular_articles = current_portal.articles.published.where(visibility: :everyone).order(views_count: :desc).limit(4).includes(:translations)
    end
  end
end
