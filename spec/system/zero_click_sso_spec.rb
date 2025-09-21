# frozen_string_literal: true

require_relative "../plugin_helper"

RSpec.describe "Zero-Click SSO", type: :system do
  context "when the plugin does nothing" do
    it "for logged-in users" do
      enable_plugin!
      mock_single_enabled_authenticator!(:oidc)

      sign_in(unique_user)
      visit "/"

      expect(page).to have_current_path("/")
      expect(page.status_code).to eq(200)
    end

    it "when there's an existing forum session", js: true do
      # loads a page so we have a DOM to run JS on
      visit "/"
      expect(page).to have_current_path("/")

      # set the Rails session cookie via JS to simulate an existing forum session
      key = Rails.application.config.session_options[:key]
      page.execute_script("document.cookie = '#{key}=dummy; path=/'")

      enable_plugin!
      mock_single_enabled_authenticator!(:oidc)

      visit "/"
      expect(page).to have_current_path("/")
    end

    it "with a non-silent provider and enable_for_noisy_providers disabled" do
      enable_plugin!(enable_for_noisy_providers: false)
      mock_single_enabled_authenticator!(:github)

      visit "/"
      expect(page).to have_current_path("/")
    end
  end

  context "when the plugin fails" do
    it "with a silent provider" do
      enable_plugin!
      mock_single_enabled_authenticator!(:oidc)

      # simulates failure + ensures the opt-out cookie is created
      visit "/zero_click_sso/failure?origin=/"
      page.execute_script("document.cookie = '_zero_click_sso=1; path=/'")

      visit "/"
      expect(page).to have_current_path("/")
    end

    it "with a non-silent provider and enable_for_noisy_providers enabled" do
      enable_plugin!(enable_for_noisy_providers: true)
      mock_single_enabled_authenticator!(:github)

      # simulates failure + ensures the opt-out cookie is created
      visit "/zero_click_sso/failure?origin=/"
      page.execute_script("document.cookie = '_zero_click_sso=1; path=/'")

      visit "/"
      expect(page).to have_current_path("/")
    end
  end

  context "when the provider is known and silent" do
    it "sends prompt=none in the authentication request" do
      enable_plugin!
      mock_single_enabled_authenticator!(:apple)

      visit "/"

      expect(page).to have_current_path(%r{\A/auth/apple(\?.*)?\z})
      expect(page.current_url).to include("prompt=none")
    end
  end

  context "when the provider is known and noisy" do
    it "omits prompt= from the authentication request" do
      enable_plugin!(enable_for_noisy_providers: true)
      mock_single_enabled_authenticator!(:github)

      visit "/"

      expect(page).to have_current_path(%r{\A/auth/github(\?.*)?\z})
      expect(page.current_url).not_to include("prompt=")
    end
  end

  context "when the provider is custom" do
    context "if consider_custom_providers_silently is true" do
      it "sends prompt=none in the authentication request" do
        enable_plugin!(consider_custom_providers_silently: true)
        mock_single_enabled_authenticator!(:custom)

        visit "/"

        expect(page).to have_current_path(%r{\A/auth/custom(\?.*)?\z})
        expect(page.current_url).to include("prompt=none")
      end
    end

    context "if consider_custom_providers_silently is false" do
      it "omits prompt= from the authentication request" do
        enable_plugin!(enable_for_noisy_providers: true)
        mock_single_enabled_authenticator!(:custom)

        visit "/"

        expect(page).to have_current_path(%r{\A/auth/custom(\?.*)?\z})
        expect(page.current_url).not_to include("prompt=")
      end
    end
  end
end
