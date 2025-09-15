# frozen_string_literal: true

module ::ZeroClickSSO
  class FailureController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    skip_before_action :redirect_to_login_if_required, only: :index

    def index
      # prevents repeated zero-click SSO attempts for a short while
      Cookies.opt_out(cookies, ttl: 1.hour)

      origin = params[:origin].presence || Discourse.base_path.presence || "/"
      redirect_to origin
    end
  end
end
