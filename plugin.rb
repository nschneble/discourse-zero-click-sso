# frozen_string_literal: true

# name: zero-click-sso
# about: Log in users automagically.
# version: 0.0.1
# authors: Nick Schneble
# url: https://github.com/nschneble/discourse-zero-click-sso
# required_version: 2.7.0

enabled_site_setting :zero_click_sso_enabled

module ::ZeroClickSSO
  PLUGIN_NAME = "zero-click-sso"
end

require_relative "lib/zero_click_sso/engine"

after_initialize do
  require_dependency "zero_click_sso/auth"
  require_dependency "zero_click_sso/cookies"
  require_dependency "zero_click_sso/requests"

  require_dependency "application_controller"
  require_dependency "session_controller"

  # only performs zero-click SSO when all conditions are met
  add_to_class(:application_controller, :perform_zero_click_sso_if_enabled) do
    return if current_user.present?
    return if ZeroClickSSO::Cookies.opted_out?(cookies)

    return unless ZeroClickSSO::Auth.configured_properly?
    return unless ZeroClickSSO::Requests.valid?(request)
    return unless ZeroClickSSO::Requests.safe_path?(request)

    base_url = ZeroClickSSO::Requests.base_url_for_auth(request)
    path = Discourse.base_path

    provider = ZeroClickSSO::Auth.provider_name
    origin = "#{base_url}#{path}"
    auth_url = "#{origin}/auth/#{provider}?prompt=none&origin=#{CGI.escape(origin)}"

    redirect_to auth_url and return
  end

  ::ApplicationController.before_action :perform_zero_click_sso_if_enabled

  # skips any zero-click SSO attempts for a short while after logging out
  add_to_class(:session_controller, :opt_out_zero_click_sso) do
    ZeroClickSSO::Cookies.opt_out(cookies, ttl: 1.hour)
  end

  ::SessionController.after_action :opt_out_zero_click_sso, only: :destroy
end

OmniAuth.config.on_failure = proc do |env|
  req = Rack::Request.new(env)
  origin = Rack::Utils.escape(req.params["origin"].to_s)

  [
    302,
    { "Location" => "#{Discourse.base_path}/zero_click_sso/failure?origin=#{origin}" },
    []
  ]
end
