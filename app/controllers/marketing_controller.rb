# frozen_string_literal: true

class MarketingController < ApplicationController
  # We do not inherit from HelpCenter::BaseController here because this is for the
  # base application domain (helpbolic.com), meaning there is no specific tenant.
  layout "marketing"
  helper StructuredDataHelper
  helper HelpCenter::MetaTagsHelper

  def index
    # TODO: When figma design is ready we will update landing page design.
  end
end
