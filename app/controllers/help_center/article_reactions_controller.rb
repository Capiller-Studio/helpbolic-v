# frozen_string_literal: true

module HelpCenter
  class ArticleReactionsController < BaseController
    before_action :set_article

    def create
      reaction = HelpCenter::ArticleReaction.find_or_initialize_by(
        article: @article,
        ip_address: request.remote_ip
      )

      reaction.assign_attributes(
        reaction_type: reaction_params[:reaction_type],
        session_id: session.id&.to_s
      )
      reaction.save!

      if request.format.turbo_stream?
        render turbo_stream: turbo_stream.replace(
          "article-feedback",
          partial: "help_center/articles/feedback",
          locals: { article: @article, article_reaction: reaction }
        )
      else
        redirect_to article_path(@article, anchor: "article-feedback"), notice: t("help_center.article.feedback_thanks")
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, ArgumentError
      if request.format.turbo_stream?
        existing_reaction = HelpCenter::ArticleReaction.find_by(article: @article, ip_address: request.remote_ip)
        render turbo_stream: turbo_stream.replace(
          "article-feedback",
          partial: "help_center/articles/feedback",
          locals: {
            article: @article,
            article_reaction: existing_reaction,
            feedback_message: t("help_center.article.feedback_error")
          }
        ), status: :unprocessable_entity
      else
        redirect_to article_path(@article, anchor: "article-feedback"), alert: t("help_center.article.feedback_error")
      end
    end

    private

    def set_article
      base_scope = current_portal.articles.published.where(visibility: :everyone).includes(:translations)

      @article = if params[:article_id].match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
        base_scope.find(params[:article_id])
      else
        base_scope.joins(:translations).find_by!(help_center_article_translations: { slug: params[:article_id] })
      end
    end

    def reaction_params
      params.require(:article_reaction).permit(:reaction_type)
    end
  end
end
