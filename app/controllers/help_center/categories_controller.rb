# frozen_string_literal: true

module HelpCenter
  class CategoriesController < BaseController
    def show
      @category = current_portal.categories.find_by!(permalink: params[:id])
      @articles = @category.articles.active.order(created_at: :desc)
    end
  end
end
