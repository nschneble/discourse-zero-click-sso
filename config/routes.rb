# frozen_string_literal: true

ZeroClickSSO::Engine.routes.draw do
  get "/failure" => "failure#index"
end

Discourse::Application.routes.draw { mount ::ZeroClickSSO::Engine, at: "/zero_click_sso" }
