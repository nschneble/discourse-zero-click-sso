# frozen_string_literal: true

DiscourseZeroClickSso::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DiscourseZeroClickSso::Engine, at: "discourse-zero-click-sso" }
