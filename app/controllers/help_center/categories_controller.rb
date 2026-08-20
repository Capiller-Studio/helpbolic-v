# frozen_string_literal: true

module HelpCenter
  class CategoriesController < BaseController
    def index
      @categories = current_portal.categories.active.where(ancestry: nil).order(position: :asc).includes(:translations)
    end

    def show
      @category = if params.expect(:id).match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
        current_portal.categories.find(params.expect(:id))
      else
        current_portal.categories.joins(:translations).find_by!(help_center_category_translations: { slug: params.expect(:id) })
      end
      @pagy_articles, @articles = pagy(@category.articles.published.where(visibility: :everyone).order(:position).includes(:translations), limit: 10, page_param: :page)

      siblings_scope = @category.parent ? @category.parent.children.active : current_portal.categories.active.where(ancestry: nil)
      @pagy_siblings, @sibling_categories = pagy(siblings_scope.where(visibility: :everyone).where.not(id: @category.id).order(:position).includes(:translations), limit: 10, page_param: :sibling_page)

      @subcategories = @category.children.active.where(visibility: :everyone).order(:position).includes(:translations)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end
end
