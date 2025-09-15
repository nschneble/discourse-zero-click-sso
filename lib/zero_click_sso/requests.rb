# frozen_string_literal: true

module ::ZeroClickSSO
  BASE_PATH = Discourse.base_path.presence || ""
  PATHS =  %w[admin auth login logout rails/active_storage zero_click_sso]

  module Requests
    def self.valid?(request)
      request.format.html? &&
      request.get? &&
      !request.xhr?
    end

    def self.safe_path?(request)
      PATHS.none? do |path|
        request.path == "#{BASE_PATH}/#{path}" ||
          request.path.start_with?("#{BASE_PATH}/#{path}/")
      end
    end

    def self.base_url_for_auth(request)
      # this allows the zero-click auth flow to work in both dev and prod
      uri = URI.parse(request.base_url)
      uri.port = ENV.fetch("DEV_RAILS_PORT", 3000).to_i if Rails.env.development?
      uri.to_s
    end
  end
end


