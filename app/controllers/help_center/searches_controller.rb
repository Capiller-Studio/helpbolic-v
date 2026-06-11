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
        @articles_page = [params[:page].to_i, 1].max
        @articles_per_page = 4
        @articles_visible_count = @articles_page * @articles_per_page

        articles_search = HelpCenter::Article.search(
          @query,
          where: {
            portal_id: current_portal.id,
            status: "published",
            visibility: "everyone",
            "translations.locale": I18n.locale.to_s
          },
          fields: ["translations.title^5", "translations.content"],
          match: :word_start,
          page: 1,
          per_page: @articles_visible_count
        )

        categories_search = HelpCenter::Category.search(
          @query,
          where: {
            portal_id: current_portal.id,
            status: "active",
            visibility: "everyone",
            "translations.locale": I18n.locale.to_s
          },
          fields: ["translations.name^5", "translations.description"],
          match: :word_start,
          limit: 5
        )

        @articles_total_count = articles_search.total_count
        @articles_next_page = @articles_page + 1 if @articles_total_count > @articles_visible_count
        @articles_previous_page = @articles_page - 1 if @articles_page > 1
        @articles = articles_search
        @categories = categories_search
      else
        @articles_page = [params[:page].to_i, 1].max
        @articles_per_page = 4
        @articles_total_count = articles_scope.count
        @articles_visible_count = @articles_page * @articles_per_page
        @articles_next_page = @articles_page + 1 if @articles_total_count > @articles_visible_count
        @articles_previous_page = @articles_page - 1 if @articles_page > 1
        @articles = articles_scope.limit(@articles_visible_count)
        @categories = categories_scope.limit(5)
      end

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

      articles = HelpCenter::Article.search(
        query,
        where: {
          portal_id: current_portal.id,
          status: "published",
          visibility: "everyone",
          "translations.locale": I18n.locale.to_s
        },
        fields: ["translations.title^5", "translations.content"],
        match: :word_start,
        limit: 2
      ).map do |article|
        translation = localized_translation(article.translations)

        {
          id: article.id,
          title: translated_value(translation, :title) || article.title,
          url: article_path(translated_value(translation, :slug) || article)
        }
      end

      categories = HelpCenter::Category.search(
        query,
        where: {
          portal_id: current_portal.id,
          status: "active",
          visibility: "everyone",
          "translations.locale": I18n.locale.to_s
        },
        fields: ["translations.name^5", "translations.description"],
        match: :word_start,
        limit: 3
      ).map do |category|
        translation = localized_translation(category.translations)

        {
          id: category.id,
          name: translated_value(translation, :name) || category.name,
          url: category_path(translated_value(translation, :slug) || category)
        }
      end

      render json: { articles: articles, categories: categories }
    end

    private

    def localized_translation(translations)
      translations.find { |translation| translated_value(translation, :locale).to_s == I18n.locale.to_s }
    end

    def translated_value(translation, attribute)
      return if translation.blank?

      translation.respond_to?(attribute) ? translation.public_send(attribute) : translation[attribute.to_s]
    end
  end
end
