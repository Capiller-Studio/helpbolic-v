# frozen_string_literal: true

module HelpCenter
  class ArticlesController < BaseController
    def show
      @article = current_portal.articles.find_by!(slug: params[:id])
    end
  end
end
