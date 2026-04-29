# frozen_string_literal: true

Rails.application.routes.draw do
  # Error Pages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#invalid_resource", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  scope "(:locale)", locale: /en|fr|de|es|ar/ do
    root to: "help_center/portals#show"

    scope module: :help_center do
      resources :categories, path: "collections", only: [:index, :show]
      resources :articles, only: [:index, :show]
    end
  end
end
