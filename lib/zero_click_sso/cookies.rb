# frozen_string_literal: true

module ::ZeroClickSSO
  module Cookies
    COOKIE_NAME = :discourse_zero_click_sso
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
      cookies.delete(COOKIE_NAME, path: COOKIE_PATH) if self.opted_out?(cookies)
    end
  end
end
