# frozen_string_literal: true

module HelpCenter
  module MetaTagsHelper
    DEFAULT_META_IMAGE = nil

    def meta_title
      content_for?(:meta_title) ? content_for(:meta_title) : (@current_portal&.name || "Help Center")
    end

    def meta_description
      content_for?(:meta_description) ? content_for(:meta_description) : (@current_portal&.description || "Help Center")
    end

    def meta_keywords
      content_for?(:meta_keywords) ? content_for(:meta_keywords) : "help center, support, faq"
    end

    def meta_image
      meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META_IMAGE)
      return nil if meta_image.blank?
      meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
    end
  end
end
