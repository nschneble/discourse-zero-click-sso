# frozen_string_literal: true

# name: zero-click-sso
# about: Log in users automagically.
# version: 0.0.1
# authors: Nick Schneble
# url: https://github.com/nschneble/discourse-zero-click-sso
# required_version: 2.7.0

enabled_site_setting :zero_click_sso_enabled

module ::ZeroClickSso
  PLUGIN_NAME = "zero-click-sso"
end

require_relative "lib/zero_click_sso/engine"

after_initialize do
  require_dependency "zero_click_sso/auth"
  require_dependency "zero_click_sso/cookies"
  require_dependency "zero_click_sso/requests"

  require_dependency "application_controller"
  require_dependency "session_controller"

  add_to_class(:application_controller, :perform_zero_click_sso_if_enabled) do
    return if current_user.present?
    return if ZeroClickSso::Cookies.opted_out?(cookies)

    # only performs zero-click SSO when all conditions are met
    return unless ZeroClickSso::Auth.configured_properly?
    return unless ZeroClickSso::Auth.no_prompt? || ZeroClickSso::Auth.try_em_all?
    return unless ZeroClickSso::Requests.valid?(request)
    return unless ZeroClickSso::Requests.safe_path?(request)

    # puts in a retry cooldown after we attempt to zero-click SSO once
    ZeroClickSso::Cookies.opt_out(cookies, ttl: 1.hour)

    base_url = ZeroClickSso::Requests.base_url_for_auth(request)
    path = Discourse.base_path.presence || "/"

    auth_params = { origin: File.join(base_url, request.fullpath) }
    auth_params[:prompt] = "none" if ZeroClickSso::Auth.no_prompt?

    auth_uri = URI(base_url)
    auth_uri.path = File.join(path, "auth", ZeroClickSso::Auth.provider_name)
    auth_uri.query = URI.encode_www_form(auth_params)

    redirect_to auth_uri.to_s and return
  end

  ::ApplicationController.before_action :perform_zero_click_sso_if_enabled

  # skips any zero-click SSO attempts for a short while after logging out
  add_to_class(:session_controller, :opt_out_zero_click_sso) do
    ZeroClickSso::Cookies.opt_out(cookies, ttl: 1.hour)
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
