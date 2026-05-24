# frozen_string_literal: true

Rails.application.routes.draw do
  # Error Pages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#invalid_resource", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Base Application Domain Route
  constraints(host: /^(localhost|helpbolic\.com|helpbolic\.localhost)$/) do
    root to: "marketing#index", as: :marketing_root
  end

  # Tenant Portals
  scope "(:locale)", locale: /[a-z]{2}(-[A-Z]{2})?/ do
    root to: "help_center/portals#show"

    scope module: :help_center do
      resources :categories, path: "collections", only: [:index, :show]
      resources :articles, only: [:index, :show]
      
      get "/search", to: "searches#index"
      get "/search/suggestions", to: "searches#suggestions"
      
      get "/contact", to: "contacts#new"
      post "/contact", to: "contacts#create"
      get "/contact/success", to: "contacts#success"
      
      get "/sitemap", to: "sitemaps#index", defaults: { format: :xml }
    end
  end
end
