# frozen_string_literal: true

module HelpCenter
  module ImageHelper
    DEVICE_WIDTHS = {
      desktop: "1200",
      tablet_landscape: "991",
      tablet_portrait: "768",
      mobile: "576"
    }.freeze

    def picture_tag(attachment, alt: "", img_class: "", attributes: "")
      return "" unless attachment.attached?

      sources = ""
      DEVICE_WIDTHS.each do |key, value|
        width = value.to_i
        # Generate variant for specific width
        variant = attachment.variant(resize_to_limit: [ width, width ]).processed
        media_query = key == :desktop ? "min-width" : "max-width"

        sources += "<source media='(#{media_query}:#{value}px)' srcset='#{url_for(variant)}'/>"
      end

      tag = <<~HTML
        <picture>
          #{sources}
          <img src='#{url_for(attachment)}' alt='#{alt}' class='#{img_class}' #{attributes} />
        </picture>
      HTML
      tag.html_safe
    end

    def lazy_picture_tag(attachment, alt: "", img_class: "", attributes: "")
      return "" unless attachment.attached?

      sources = ""
      DEVICE_WIDTHS.each do |key, value|
        width = value.to_i
        variant = attachment.variant(resize_to_limit: [ width, width ]).processed
        media_query = key == :desktop ? "min-width" : "max-width"

        sources += "<source media='(#{media_query}:#{value}px)' data-srcset='#{url_for(variant)}'/>"
      end

      tag = <<~HTML
        <picture>
          #{sources}
          <img data-src='#{url_for(attachment)}' height='100%' width='100%' alt='#{alt}' class='lazy #{img_class}' loading='lazy' #{attributes} />
        </picture>
      HTML
      tag.html_safe
    end
  end
end
