# frozen_string_literal: true

require_relative "../plugin_helper"

RSpec.describe "Zero-Click SSO", type: :system do
  context "plugin does nothing" do
    it "for logged-in users" do
      enable_plugin!
      mock_single_enabled_authenticator!(:oidc)

      sign_in(unique_user)
      visit "/"

      expect(page).to have_current_path("/")
      expect(page.status_code).to eq(200)
    end

    it "when there's an existing forum session" do
      enable_plugin!
      mock_single_enabled_authenticator!(:oidc)

      # creates an anonymous forum session
      visit "/"

      expect(page).to have_current_path("/")
      expect(page.driver.request.cookies[forum_session_cookie_key]).to be_present

      visit "/"

      expect(page).to have_current_path("/")
    end

    it "with a non-silent provider and attempt_for_all_providers disabled" do
      enable_plugin!(attempt_for_all_providers: false)
      mock_single_enabled_authenticator!(:github)

      visit "/"

      expect(page).to have_current_path("/")
    end
  end

  context "plugin fails" do
    it "with a silent provider" do
      enable_plugin!
      mock_single_enabled_authenticator!(:oidc)

      visit "/zero_click_sso/failure?origin=/"

      visit "/"
      expect(page).to have_current_path("/")
    end

    it "with a non-silent provider and attempt_for_all_providers enabled" do
      enable_plugin!(attempt_for_all_providers: true)
      mock_single_enabled_authenticator!(:github)

      visit "/zero_click_sso/failure?origin=/"

      visit "/"
      expect(page).to have_current_path("/")
    end
  end
end
