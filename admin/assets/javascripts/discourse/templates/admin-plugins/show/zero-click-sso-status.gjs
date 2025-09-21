import { htmlSafe } from "@ember/template";
import RouteTemplate from "ember-route-template";
import { and, not, or } from "truth-helpers";
import DBreadcrumbsItem from "discourse/components/d-breadcrumbs-item";
import DPageSubheader from "discourse/components/d-page-subheader";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

function statusLabel(value) {
  return htmlSafe(
    `<span class="zero-click-sso-status-badge ${value ? "zero-click-sso-good-value" : "zero-click-sso-bad-value"}">${
      value
        ? i18n("zero_click_sso.admin.good")
        : i18n("zero_click_sso.admin.bad")
    }</span>`
  );
}

export default RouteTemplate(
  <template>
    <DBreadcrumbsItem
      @path="/admin/plugins/{{@controller.adminPluginNavManager.currentPlugin.name}}/status"
      @label={{i18n "zero_click_sso.status"}}
    />

    <div class="zero-click-sso__status admin-detail">
      <DPageSubheader @titleLabel={{i18n "zero_click_sso.admin.title"}} />
      <div class="zero-click-sso-status-attributes">
        {{#if @model}}
          <table>
            <thead>
              <th>{{icon "check"}}</th>
              <th>{{i18n "zero_click_sso.admin.attribute"}}</th>
            </thead>

            <tbody>
              <tr>
                <td class="zero-click-sso-status-attribute">{{statusLabel
                    @model.plugin_enabled
                  }}</td>
                <td class="zero-click-sso-status-attribute">{{i18n
                    "zero_click_sso.admin.attributes.plugin_enabled"
                  }}</td>
              </tr>
              {{#if (and (not @model.no_prompt) @model.single_sso)}}
                <tr>
                  <td class="zero-click-sso-status-attribute">{{statusLabel
                      @model.attempt_for_all_providers
                    }}</td>
                  <td class="zero-click-sso-status-attribute">{{i18n
                      "zero_click_sso.admin.attributes.attempt_for_all_providers"
                    }}</td>
                </tr>
              {{/if}}
              <tr>
                <td class="zero-click-sso-status-attribute">{{statusLabel
                    (not @model.local_logins_enabled)
                  }}</td>
                <td class="zero-click-sso-status-attribute">{{i18n
                    "zero_click_sso.admin.attributes.local_logins_enabled"
                  }}</td>
              </tr>
              <tr>
                <td class="zero-click-sso-status-attribute">{{statusLabel
                    @model.single_sso
                  }}</td>
                <td class="zero-click-sso-status-attribute">{{i18n
                    "zero_click_sso.admin.attributes.single_sso"
                  }}</td>
              </tr>
            </tbody>
          </table>
        {{/if}}

        <div class="zero-click-sso-info">
          {{#if
            (and
              @model.plugin_enabled
              (not @model.local_logins_enabled)
              @model.single_sso
            )
          }}
            {{#if (or @model.no_prompt @model.attempt_for_all_providers)}}
              <p class="zero-click-sso-ready">{{i18n
                  "zero_click_sso.admin.info.ready"
                  provider=@model.provider
                }}</p>
            {{else}}
              <p class="zero-click-sso-nearly-ready">{{i18n
                  "zero_click_sso.admin.info.nearly_ready"
                  provider=@model.provider
                }}</p>
            {{/if}}
          {{else}}
            <p class="zero-click-sso-not-ready">{{i18n
                "zero_click_sso.admin.info.not_ready"
              }}</p>
          {{/if}}
        </div>
      </div>
    </div>
  </template>
);
