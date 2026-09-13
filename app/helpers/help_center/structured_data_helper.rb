# frozen_string_literal: true

module HelpCenter
  module StructuredDataHelper
    include ActionView::Helpers::SanitizeHelper

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

      cat_slug = category.slug.presence || category.id
      items = [
        {
          "@type" => "ListItem",
          "position" => 1,
          "name" => I18n.t("help_center.common.home", default: "Home"),
          "item" => root_url
        }
      ]

      pos = 2
      category.ancestors.each do |ancestor|
        items << {
          "@type" => "ListItem",
          "position" => pos,
          "name" => ancestor.name.to_s,
          "item" => category_url(id: ancestor.slug.presence || ancestor.id)
        }
        pos += 1
      end

      items << {
        "@type" => "ListItem",
        "position" => pos,
        "name" => category.name.to_s,
        "item" => category_url(id: cat_slug)
      }

      {
        "@context" => "https://schema.org",
        "@graph" => [
          {
            "@type" => "CollectionPage",
            "url" => category_url(id: cat_slug),
            "name" => category.name.to_s,
            "description" => category.description.to_s
          },
          {
            "@type" => "BreadcrumbList",
            "itemListElement" => items
          }
        ]
      }
    end

    def article_structured_data(article, portal)
      return {} if article.blank?

      art_slug = article.slug.presence || article.id
      images = []
      if article.respond_to?(:banner_image) && article.banner_image&.attached?
        begin
          images << url_for(article.banner_image)
        rescue StandardError
          nil
        end
      end
      if images.empty? && portal&.social_share_image&.attached?
        begin
          images << url_for(portal.social_share_image)
        rescue StandardError
          nil
        end
      end
      if images.empty? && portal&.logo&.attached?
        begin
          images << url_for(portal.logo)
        rescue StandardError
          nil
        end
      end

      items = [
        {
          "@type" => "ListItem",
          "position" => 1,
          "name" => I18n.t("help_center.common.home", default: "Home"),
          "item" => root_url
        }
      ]

      pos = 2
      if article.primary_category
        article.primary_category.ancestors.each do |ancestor|
          items << {
            "@type" => "ListItem",
            "position" => pos,
            "name" => ancestor.name.to_s,
            "item" => category_url(id: ancestor.slug.presence || ancestor.id)
          }
          pos += 1
        end

        items << {
          "@type" => "ListItem",
          "position" => pos,
          "name" => article.primary_category.name.to_s,
          "item" => category_url(id: article.primary_category.slug.presence || article.primary_category.id)
        }
        pos += 1
      end

      items << {
        "@type" => "ListItem",
        "position" => pos,
        "name" => article.title.to_s,
        "item" => article_url(id: art_slug)
      }

      {
        "@context" => "https://schema.org",
        "@graph" => [
          {
            "@type" => "Article",
            "mainEntityOfPage" => {
              "@type" => "WebPage",
              "@id" => article_url(id: art_slug)
            },
            "headline" => article.title.to_s,
            "description" => strip_tags(article.content.to_s).truncate(160),
            "image" => images,
            "datePublished" => article.created_at&.iso8601,
            "dateModified" => article.updated_at&.iso8601,
            "author" => {
              "@type" => "Organization",
              "name" => portal&.name.to_s
            },
            "publisher" => {
              "@type" => "Organization",
              "name" => portal&.name.to_s
            }
          },
          {
            "@type" => "BreadcrumbList",
            "itemListElement" => items
          }
        ]
      }
    end
  end
end
