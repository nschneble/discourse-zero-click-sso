# frozen_string_literal: true

module ::ZeroClickSso
  class StatusController < ::Admin::AdminController
    requires_plugin PLUGIN_NAME

    skip_before_action :check_xhr, only: :show

    def show
      authenticators = Discourse.enabled_authenticators.map(&:name)

      render json: {
        plugin_enabled: SiteSetting.zero_click_sso_enabled,
        attempt_for_all_providers: SiteSetting.zero_click_sso_enabled_for_noisy_providers,
        local_logins_enabled: SiteSetting.enable_local_logins,
        enabled_authenticators: authenticators,
        single_sso: authenticators.one?,
        provider: authenticators.first,
        no_prompt: Auth.no_prompt?
      }
    end
  end
end
