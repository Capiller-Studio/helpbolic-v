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
      # Determine sibling articles for guide_mode pagination
      if @category&.guide_mode?
        @category_articles = @category.articles.published.where(visibility: :everyone).order(:position).includes(:translations).to_a
        current_index = @category_articles.index { |a| a.id == @article.id }
        if current_index
          @prev_article = @category_articles[current_index - 1] if current_index > 0
          @next_article = @category_articles[current_index + 1] if current_index < @category_articles.size - 1
        end
      end
      
      @article_reaction = HelpCenter::ArticleReaction.find_by(article: @article, ip_address: request.remote_ip)

      # Increment view count in a background job or silently
      HelpCenter::Article.increment_counter(:views_count, @article.id, touch: false)
    end
  end
end
