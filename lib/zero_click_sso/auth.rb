# frozen_string_literal: true

module ::ZeroClickSso
  module Auth
    # names match Discourse authenticators' names
    NO_PROMPT_AUTHENTICATORS = %w[
      apple
      google_oauth2
      linkedin_oidc
      microsoft_office365
      oidc
    ]

    # names match Discourse authenticators' names
    THE_LESS_CONSIDERATE_AUTHENTICATORS = %w[
      amazon
      discord
      discourse_id
      facebook
      github
      oauth2_basic
      patreon
      twitter
    ]

    def self.configured_properly?
      return false unless Discourse.enabled_authenticators.one?
      return false unless SiteSetting.zero_click_sso_enabled
      return false if SiteSetting.enable_local_logins

      true
    end

    def self.provider_name
      Discourse.enabled_authenticators.first&.name&.to_s
    end

    def self.no_prompt?
      NO_PROMPT_AUTHENTICATORS.include?(provider_name) || (custom_provider? &&
        SiteSetting.zero_click_sso_consider_custom_providers_silently)
    end

    def self.custom_provider?
      return false if NO_PROMPT_AUTHENTICATORS.include?(provider_name)
      return false if THE_LESS_CONSIDERATE_AUTHENTICATORS.include?(provider_name)

      true
    end

    def self.try_em_all?
      SiteSetting.zero_click_sso_enabled_for_noisy_providers
    end
  end
end
