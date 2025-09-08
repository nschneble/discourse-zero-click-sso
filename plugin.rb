# frozen_string_literal: true

# name: discourse-zero-click-sso
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_zero_click_sso_enabled

module ::DiscourseZeroClickSso
  PLUGIN_NAME = "discourse-zero-click-sso"
end

require_relative "lib/discourse_zero_click_sso/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
