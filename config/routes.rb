# frozen_string_literal: true

ZeroClickSso::Engine.routes.draw do
  get "/failure" => "failure#index"
end

require_dependency "zero_click_sso/status_controller"

Discourse::Application.routes.draw do
  mount ::ZeroClickSso::Engine, at: "/zero_click_sso"

  get "/admin/plugins/zero-click-sso" => "admin/plugins#index",
      constraints: StaffConstraint.new
  get "/admin/plugins/zero-click-sso/status" => "admin/plugins#index",
      constraints: StaffConstraint.new
  get "/zero-click-sso/status" => "zero_click_sso/status#show",
      constraints: StaffConstraint.new,
      defaults: { format: :json }
end
