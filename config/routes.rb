# frozen_string_literal: true

ZeroClickSso::Engine.routes.draw do
  get "/failure" => "failure#index"
end

Discourse::Application.routes.draw do
  mount ::ZeroClickSso::Engine, at: "/zero_click_sso"

  get "/admin/plugins/zero-click-sso" => "admin/plugins#index", constraints: StaffConstraint.new
  get "/admin/plugins/zero-click-sso/status" => "admin/plugins#index", constraints: StaffConstraint.new
end
