# frozen_string_literal: true

module HelpCenter
  class ArticlesController < BaseController
    def show
      base_scope = current_portal.articles.published.where(visibility: :everyone).includes(:translations)
      
      @article = if params[:id].match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
        base_scope.find(params[:id])
      else
        base_scope.joins(:translations).find_by!(help_center_article_translations: { slug: params[:id] })
      end
      
      if @article.external_link?
        redirect_to @article.configurations["external_url"], allow_other_host: true
        return
      end
      
      @category = @article.primary_category

      load_sidebar_navigation

      # Determine sibling articles for guide_mode pagination
      if @category&.guide_mode?
        @category_articles = @category.articles.published.where(visibility: :everyone).order(:position).includes(:translations).to_a
        current_index = @category_articles.index { |a| a.id == @article.id }
        if current_index
          @guide_current_index = current_index
          @guide_total_articles = @category_articles.size
          @prev_article = @category_articles[current_index - 1] if current_index > 0
          @next_article = @category_articles[current_index + 1] if current_index < @category_articles.size - 1
        end
      end
      
      @article_reaction = HelpCenter::ArticleReaction.find_by(article: @article, ip_address: request.remote_ip)

      # Increment view count in a background job or silently
      HelpCenter::Article.increment_counter(:views_count, @article.id, touch: false)
    end

    private

    def load_sidebar_navigation
      return unless @category

      @sidebar_categories = @category
        .portal
        .categories
        .where(visibility: :everyone)
        .order(:position)
        .includes(:translations)
        .with_attached_image
        .to_a

      category_resources = HelpCenter::CategoryResource
        .where(category_id: @sidebar_categories.map(&:id), resource_type: "HelpCenter::Article")
        .joins("INNER JOIN help_center_articles ON help_center_articles.id = help_center_category_resources.resource_id")
        .where(help_center_articles: { status: HelpCenter::Article.statuses[:published], visibility: HelpCenter::Article.visibilities[:everyone] })
        .order("help_center_category_resources.category_id ASC, help_center_articles.position ASC, help_center_articles.id ASC")
        .includes(resource: :translations)
        .to_a

      @sidebar_articles_by_category_id = category_resources.group_by(&:category_id).transform_values do |resources|
        resources.map(&:resource)
      end
    end
  end
end
