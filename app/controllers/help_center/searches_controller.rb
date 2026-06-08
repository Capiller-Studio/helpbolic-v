# frozen_string_literal: true

module HelpCenter
  class SearchesController < BaseController
    def index
      @query = params[:query].to_s.strip
      @active_tab = params[:tab].to_s == "categories" ? "categories" : "articles"

      articles_scope = current_portal
        .articles
        .published
        .where(visibility: :everyone)
        .order(Arel.sql("help_center_articles.position ASC NULLS LAST, help_center_articles.updated_at DESC"))
        .includes(:translations, :primary_category)

      categories_scope = current_portal
        .categories
        .active
        .where(visibility: :everyone)
        .order(Arel.sql("help_center_categories.position ASC NULLS LAST, help_center_categories.updated_at DESC"))
        .includes(:translations)

      if @query.present?
        search_term = "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"
        articles_scope = articles_scope
          .joins(:translations)
          .where(help_center_article_translations: { locale: I18n.locale.to_s })
          .where(
            "help_center_article_translations.title ILIKE :query OR help_center_article_translations.content ILIKE :query",
            query: search_term
          )
          .distinct

        categories_scope = categories_scope
          .joins(:translations)
          .where(help_center_category_translations: { locale: I18n.locale.to_s })
          .where(
            "help_center_category_translations.name ILIKE :query OR help_center_category_translations.description ILIKE :query",
            query: search_term
          )
          .distinct
      end
      
      @articles_page = [params[:page].to_i, 1].max
      @articles_per_page = 4
      @articles_total_count = articles_scope.count
      @articles_visible_count = @articles_page * @articles_per_page
      @articles_next_page = @articles_page + 1 if @articles_total_count > @articles_visible_count
      @articles_previous_page = @articles_page - 1 if @articles_page > 1
      @articles = articles_scope.limit(@articles_visible_count)
      @categories = categories_scope.limit(5)

      @category_article_counts = HelpCenter::CategoryResource
        .joins("INNER JOIN help_center_articles ON help_center_articles.id = help_center_category_resources.resource_id AND help_center_category_resources.resource_type = 'HelpCenter::Article'")
        .where(category_id: @categories.map(&:id))
        .where(help_center_articles: { status: HelpCenter::Article.statuses[:published], visibility: HelpCenter::Article.visibilities[:everyone] })
        .group(:category_id)
        .count
    end

    def suggestions
      query = params[:query].to_s.strip
      
      if query.blank?
        render json: { articles: [], categories: [] }
        return
      end
      
      search_term = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
      articles = current_portal
        .articles
        .published
        .where(visibility: :everyone)
        .joins(:translations)
        .where(help_center_article_translations: { locale: I18n.locale.to_s })
        .where(
          "help_center_article_translations.title ILIKE :query OR help_center_article_translations.content ILIKE :query",
          query: search_term
        )
        .distinct
        .order(Arel.sql("help_center_articles.position ASC NULLS LAST, help_center_articles.updated_at DESC"))
        .limit(2)
        .includes(:translations)
        .map do |article|
          {
            id: article.id,
            title: article.title,
            url: article_path(article)
          }
        end
      
      render json: { articles: articles, categories: [] }
    end
  end
end
