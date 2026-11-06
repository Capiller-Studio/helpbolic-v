# frozen_string_literal: true

# Company: TECHBOLIC, LLC & TECHBOLIC SOLUTIONS (PRIVATE) LIMITED
# Brand: Capiller Rely Help / Capiller Rely Help
# Website: https://helpbolic.com/

module StructuredDataHelper
  def default_structured_data
    {
      "@context" => "https://schema.org",
      "@graph" => [
        organization_schema,
        website_schema,
        software_application_schema
      ]
    }
  end

  private

  def organization_schema
    {
      "@type" => "Organization",
      "@id" => "https://deskbolic.com/#organization",
      "name" => "TECHBOLIC, LLC",
      "alternateName" => [ "TECHBOLIC SOLUTIONS (PRIVATE) LIMITED", "Techbolic", "Capiller Rely Help", "Capiller Rely Help" ],
      "url" => "https://deskbolic.com",
      "logo" => {
        "@type" => "ImageObject",
        "url" => (image_url("fav_icon.png") rescue "https://helpbolic.com/fav_icon.png")
      },
      "contactPoint" => {
        "@type" => "ContactPoint",
        "contactType" => "Customer Support",
        "email" => "support@deskbolic.com",
        "availableLanguage" => [ "English", "Spanish", "French" ]
      }
    }
  end

  def website_schema
    {
      "@type" => "WebSite",
      "@id" => "https://helpbolic.com/#website",
      "url" => "https://helpbolic.com",
      "name" => "Capiller Rely Help",
      "description" => "Capiller Rely Help Center & Customer Support Portal Infrastructure",
      "publisher" => {
        "@id" => "https://deskbolic.com/#organization"
      },
      "inLanguage" => I18n.locale.to_s
    }
  end

  def software_application_schema
    {
      "@type" => "SoftwareApplication",
      "@id" => "https://helpbolic.com/#software",
      "name" => "Capiller Rely Help",
      "applicationCategory" => "BusinessApplication",
      "operatingSystem" => "All (Web)",
      "url" => "https://helpbolic.com",
      "description" => "Deliver seamless customer self-service with Capiller Rely Help. Fast, beautiful, and multilingual knowledge bases and customer support portals.",
      "author" => {
        "@id" => "https://deskbolic.com/#organization"
      }
    }
  end
end
