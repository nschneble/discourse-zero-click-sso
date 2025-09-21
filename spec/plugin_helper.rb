# frozen_string_literal: true

require "rails_helper"

module ZeroClickSsoHelpers
  def mock_single_enabled_authenticator!(name)
    authenticator = instance_double("Auth::Authenticator", name: name)
    allow(Discourse).to receive(:enabled_authenticators).and_return([authenticator])
  end

  def enable_plugin!(enable_for_noisy_providers: false, consider_custom_providers_silently: false)
    # Discourse site settings
    SiteSetting.enable_local_logins = false

    # zero-click SSO plugin settings
    SiteSetting.zero_click_sso_enabled = true
    SiteSetting.zero_click_sso_enabled_for_noisy_providers = enable_for_noisy_providers
    SiteSetting.zero_click_sso_consider_custom_providers_silently = consider_custom_providers_silently
  end

  def forum_session_cookie_key
    Rails.application.config.session_options[:key]
  end

  def unique_user
    Fabricate(:user, email: Faker::Internet.unique.email, username: Faker::Internet.unique.username)
  end
end

RSpec.configure { |config| config.include ZeroClickSsoHelpers }
