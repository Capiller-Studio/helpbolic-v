# frozen_string_literal: true

module HelpCenter
  module AvatarHelper
    def display_name(resource)
      resource.display_name.presence || resource.name.presence ||
        [ resource.first_name, resource.middle_name, resource.last_name ].compact_blank.join(" ").presence ||
        resource.email.to_s.presence
    end

    def initials(resource)
      return "?" if display_name(resource).blank?

      display_name(resource).first.upcase
    end
  end
end
