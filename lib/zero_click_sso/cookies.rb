# frozen_string_literal: true

module ::ZeroClickSso
  module Cookies
    COOKIE_NAME = :_zero_click_sso
    COOKIE_PATH = "/"

    def self.opt_out(cookies, ttl: 1.hour)
      cookies[COOKIE_NAME] = {
        value: "1",
        path: COOKIE_PATH,
        max_age: ttl.to_i,
        same_site: :lax,
        secure: SiteSetting.force_https,
        httponly: false
      }
    end

    def self.opted_out?(cookies)
      cookies[COOKIE_NAME].present?
    end

    def self.clear(cookies)
      cookies.delete(COOKIE_NAME, path: COOKIE_PATH) if opted_out?(cookies)
    end

    def self.session?(cookies)
      session_key = Rails.application.config.session_options[:key]
      cookies[session_key].present?
    end
  end
end
