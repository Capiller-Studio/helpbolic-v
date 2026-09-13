# frozen_string_literal: true

module HelpCenter
  module MetaTagsHelper
    DEFAULT_META_IMAGE = nil

    def set_meta_tags(title: nil, description: nil, keywords: nil, image: nil, type: "website")
      content_for(:title, title) if title.present?
      content_for(:meta_title, title) if title.present?
      content_for(:meta_description, description) if description.present?
      content_for(:meta_keywords, keywords) if keywords.present?
      content_for(:meta_image, image) if image.present?
      content_for(:og_type, type) if type.present?
    end

    def meta_title
      if content_for?(:meta_title)
        content_for(:meta_title)
      elsif content_for?(:title)
        content_for(:title)
      else
        @current_portal&.name || "Help Center"
      end
    end

    def meta_description
      if content_for?(:meta_description)
        content_for(:meta_description)
      else
        @current_portal&.description || "Help Center"
      end
    end

    def meta_keywords
      content_for?(:meta_keywords) ? content_for(:meta_keywords) : "help center, support, faq"
    end

    def meta_og_type
      content_for?(:og_type) ? content_for(:og_type) : "website"
    end

    def meta_image
      if content_for?(:meta_image)
        img = content_for(:meta_image)
        return img.to_s.start_with?("http") ? img : image_url(img)
      end

      if @current_portal&.social_share_image&.attached?
        begin
          return url_for(@current_portal.social_share_image)
        rescue StandardError
          nil
        end
      end

      if @current_portal&.logo&.attached?
        begin
          return url_for(@current_portal.logo)
        rescue StandardError
          nil
        end
      end

      nil
    end

    def portal_favicon_url
      if @current_portal&.favicon&.attached?
        begin
          return url_for(@current_portal.favicon)
        rescue StandardError
          nil
        end
      end

      begin
        image_url("fav_icon.png")
      rescue StandardError
        "/favicon.ico"
      end
    end

    def canonical_url
      safe_params = if respond_to?(:params) && params.present?
        params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : (params.respond_to?(:to_h) ? params.to_h : {})
      else
        {}
      end

      host_opt = {}
      if !respond_to?(:default_url_options) || default_url_options[:host].blank?
        portal_host = @current_portal&.domain&.value || (request.respond_to?(:host) ? request.host : nil)
        host_opt[:host] = portal_host if portal_host.present?
      end

      if @current_portal
        locale_param = (I18n.locale.to_s == @current_portal.default_locale.to_s ? nil : I18n.locale)
        if safe_params[:controller].present?
          url_for(safe_params.merge(host_opt).merge(locale: locale_param, only_path: false))
        else
          root_url(host_opt.merge(locale: locale_param))
        end
      else
        if safe_params[:controller].present?
          url_for(safe_params.merge(host_opt).merge(only_path: false))
        else
          root_url(host_opt)
        end
      end
    rescue StandardError
      request.respond_to?(:original_url) ? request.original_url : "/"
    end

    def hreflang_links
      return [] unless @current_portal&.locales&.many?

      safe_params = if respond_to?(:params) && params.present?
        params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : (params.respond_to?(:to_h) ? params.to_h : {})
      else
        {}
      end

      host_opt = {}
      if !respond_to?(:default_url_options) || default_url_options[:host].blank?
        portal_host = @current_portal&.domain&.value || (request.respond_to?(:host) ? request.host : nil)
        host_opt[:host] = portal_host if portal_host.present?
      end

      @current_portal.locales.filter_map do |loc|
        locale_param = (loc.to_s == @current_portal.default_locale.to_s ? nil : loc)
        target_url = if safe_params[:controller].present?
          url_for(safe_params.merge(host_opt).merge(locale: locale_param, only_path: false))
        else
          root_url(host_opt.merge(locale: locale_param))
        end
        { locale: loc, url: target_url }
      rescue StandardError
        nil
      end
    end

    def robots_content
      return content_for(:robots) if content_for?(:robots)
      return "noindex, nofollow" if controller_name == "errors"

      if @current_portal
        @current_portal.indexing_enabled? ? "index, follow" : "noindex, nofollow"
      else
        "index, follow"
      end
    end
  end
end
