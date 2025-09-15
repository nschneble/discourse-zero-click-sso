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
      SiteSetting.zero_click_sso_enabled &&
      !SiteSetting.enable_local_logins &&
      Discourse.enabled_authenticators.one?
    end

    def self.provider_name
      Discourse.enabled_authenticators.first&.name
    end

    def self.no_prompt?
      NO_PROMPT_AUTHENTICATORS.include?(provider_name)
    end

    def self.try_em_all?
      SiteSetting.attempt_zero_click_sso_for_all_providers
    end
  end
end
