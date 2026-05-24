# frozen_string_literal: true

module HelpCenter
  class SearchesController < BaseController
    def index
      @query = params[:query].to_s.strip
      
      if @query.blank?
        @pagy_articles, @articles = pagy(HelpCenter::Article.none)
        @categories = []
        return
      end
      
      # Search Articles
      articles_search = HelpCenter::Article.search(
        @query,
        where: { 
          portal_id: current_portal.id,
          status: "published", 
          visibility: "everyone"
        },
        fields: [{"translations.title^5" => :word_start}, {"translations.content" => :word_start}],
        highlight: { tag: "<mark>", fields: {"translations.title" => {}, "translations.content" => { fragment_size: 150 }} },
        page: params[:page] || 1,
        per_page: 10
      )
      
      @articles = articles_search
      @pagy_articles = Pagy.new(count: articles_search.total_count, page: params[:page] || 1, items: 10)
      
      # Search Categories
      @categories = HelpCenter::Category.search(
        @query,
        where: { 
          portal_id: current_portal.id,
          status: "active", 
          visibility: "everyone"
        },
        fields: [{"translations.name^5" => :word_start}, {"translations.description" => :word_start}],
        limit: 5
      )
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
          visibility: "everyone"
        },
        fields: [{"translations.title^5" => :word_start}, {"translations.content" => :word_start}],
        limit: 5,
        load: false
      ).map do |article|
        {
          id: article.id,
          title: article.translations.find { |t| t["locale"] == I18n.locale.to_s }&.dig("title") || article.title,
          url: article_path(article.translations.find { |t| t["locale"] == I18n.locale.to_s }&.dig("slug") || article.id)
        }
      end
      
      categories = HelpCenter::Category.search(
        query,
        where: { 
          portal_id: current_portal.id,
          status: "active", 
          visibility: "everyone"
        },
        fields: [{"translations.name^5" => :word_start}, {"translations.description" => :word_start}],
        limit: 3,
        load: false
      ).map do |category|
        {
          id: category.id,
          name: category.translations.find { |t| t["locale"] == I18n.locale.to_s }&.dig("name") || category.name,
          url: category_path(category.translations.find { |t| t["locale"] == I18n.locale.to_s }&.dig("slug") || category.id)
        }
      end
      
      render json: { articles: articles, categories: categories }
    end
  end
end
