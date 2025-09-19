import RouteTemplate from "ember-route-template";
import DBreadcrumbsItem from "discourse/components/d-breadcrumbs-item";
import DPageSubheader from "discourse/components/d-page-subheader";
import { i18n } from "discourse-i18n";

export default RouteTemplate(
  <template>
    <DBreadcrumbsItem
      @path="/admin/plugins/{{@controller.adminPluginNavManager.currentPlugin.name}}/status"
      @label={{i18n "zero_click_sso.status"}}
    />

    <div class="zero-click-sso__status admin-detail">
      <DPageSubheader @titleLabel={{i18n "zero_click_sso.status"}} />

      {{#if @controller.siteSettings.zero_click_sso_enabled}}
        {{#if
          @controller.siteSettings.zero_click_sso_enabled_for_noisy_providers
        }}
          <p
            style="background-color: darkgreen; color: white; padding: 8px 12px;"
          >
            <em>Enabled for all providers</em>
          </p>
        {{else}}
          <p
            style="background-color: darkgoldenrod; color: white; padding: 8px 12px;"
          >
            <em>Enabled for silent providers</em>
          </p>
        {{/if}}
      {{else}}
        <p style="background-color: darkred; color: white; padding: 8px 12px;">
          <em>Disabled</em>
        </p>
      {{/if}}

      {{#if @model}}
        <div class="admin-config-page__main-area">
          <dl class="pairs">
            <dt>Plugin enabled</dt><dd>{{@model.plugin_enabled}}</dd>
            <dt>attempt_for_all_providers</dt><dd
            >{{@model.attempt_for_all_providers}}</dd>
            <dt>Local logins enabled</dt><dd
            >{{@model.local_logins_enabled}}</dd>
            <dt>Enabled authenticators</dt><dd
            >{{@model.enabled_authenticators}}</dd>
            <dt>Single SSO</dt><dd>{{@model.single_sso}}</dd>
            <dt>Provider</dt><dd>{{@model.provider}}</dd>
            <dt>Silent-capable</dt><dd>{{@model.no_prompt}}</dd>
          </dl>
        </div>
      {{/if}}
    </div>
  </template>
);
