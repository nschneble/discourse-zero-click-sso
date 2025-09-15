# frozen_string_literal: true

module ::ZeroClickSSO
  module Auth
    def self.configured_properly?
      SiteSetting.zero_click_sso_enabled &&
      !SiteSetting.enable_local_logins &&
      Discourse.enabled_authenticators.one? &&
      self.provider_name.present?
    end

    def self.provider_name
      Discourse.enabled_authenticators.first&.name
    end
  end
end
