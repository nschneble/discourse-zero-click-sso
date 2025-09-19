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
    </div>
  </template>
);
