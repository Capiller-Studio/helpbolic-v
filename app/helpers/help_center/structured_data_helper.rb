# frozen_string_literal: true

module HelpCenter
  module StructuredDataHelper
    def portal_structured_data(portal)
      return {} if portal.blank?

      {
        "@context" => "https://schema.org",
        "@type" => "WebSite",
        "url" => root_url,
        "name" => portal.name.to_s,
        "description" => portal.description.to_s
      }
    end

    def category_structured_data(category)
      return {} if category.blank?

      {
        "@context" => "https://schema.org",
        "@type" => "CollectionPage",
        "url" => category_url(id: category.slug),
        "name" => category.name.to_s,
        "description" => category.description.to_s
      }
    end

    def article_structured_data(article, portal)
      return {} if article.blank?

      images = []
      if portal&.logo&.attached?
        begin
          images << url_for(portal.logo)
        rescue StandardError
          nil
        end
      end

      {
        "@context" => "https://schema.org",
        "@type" => "Article",
        "headline" => article.title.to_s,
        "image" => images,
        "datePublished" => article.created_at&.iso8601,
        "dateModified" => article.updated_at&.iso8601,
        "author" => {
          "@type" => "Organization",
          "name" => portal&.name.to_s
        }
      }
    end
  end
end
