# frozen_string_literal: true

ZeroClickSso::Engine.routes.draw do
  get "/failure" => "failure#index"
end

Discourse::Application.routes.draw { mount ::ZeroClickSso::Engine, at: "/zero_click_sso" }
