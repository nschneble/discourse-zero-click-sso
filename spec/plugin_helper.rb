# frozen_string_literal: true

require "rails_helper"

module ZeroClickSsoHelpers
  def mock_single_enabled_authenticator!(name)
    authenticator = instance_double("Auth::Authenticator", name: name)
    allow(Discourse).to receive(:enabled_authenticators).and_return([authenticator])
  end

  def enable_plugin!(attempt_for_all_providers: false, show_excitement: false, excitement_level: 1)
    # Discourse site settings
    SiteSetting.enable_local_logins = false

    # zero-click SSO plugin settings
    SiteSetting.zero_click_sso_enabled = true
    SiteSetting.attempt_zero_click_sso_for_all_providers = attempt_for_all_providers
    SiteSetting.show_excitement = show_excitement
    SiteSetting.excitement_level = excitement_level
  end

  def forum_session_cookie_key
    Rails.application.config.session_options[:key]
  end

  def unique_user
    Fabricate(:user, email: Faker::Internet.unique.email, username: Faker::Internet.unique.username)
  end
end

RSpec.configure { |config| config.include ZeroClickSsoHelpers }
