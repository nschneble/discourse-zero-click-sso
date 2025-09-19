import RouteTemplate from "ember-route-template";
import DBreadcrumbsItem from "discourse/components/d-breadcrumbs-item";
import DPageSubheader from "discourse/components/d-page-subheader";
import { htmlSafe } from "@ember/template";
import { i18n } from "discourse-i18n";
import { and, not, or } from "truth-helpers";

function statusLabel(value) {
  return htmlSafe(
    `<span class="zero-click-sso-status-badge ${value ? "good-value" : "bad-value"}">${
      value
        ? I18n.t("zero_click_sso.admin.good")
        : I18n.t("zero_click_sso.admin.bad")
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
              <th>{{i18n "zero_click_sso.admin.value"}}</th>
              <th>{{i18n "zero_click_sso.admin.attribute"}}</th>
            </thead>

            <tbody>
              <tr>
                <td>{{statusLabel @model.plugin_enabled}}</td>
                <td>{{i18n
                    "zero_click_sso.admin.attributes.plugin_enabled"
                  }}</td>
              </tr>
              {{#unless (or @model.no_prompt (not @model.single_sso))}}
                <tr>
                  <td>{{statusLabel @model.attempt_for_all_providers}}</td>
                  <td>{{i18n
                      "zero_click_sso.admin.attributes.attempt_for_all_providers"
                    }}</td>
                </tr>
              {{/unless}}
              <tr>
                <td>{{statusLabel (not @model.local_logins_enabled)}}</td>
                <td>{{i18n
                    "zero_click_sso.admin.attributes.local_logins_enabled"
                  }}</td>
              </tr>
              <tr>
                <td>{{statusLabel @model.single_sso}}</td>
                <td>{{i18n "zero_click_sso.admin.attributes.single_sso"}}</td>
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
              <p class="ready">{{i18n "zero_click_sso.admin.info.ready_prefix"}}
                {{@model.provider}}{{i18n
                  "zero_click_sso.admin.info.ready_suffix"
                }}</p>
            {{else}}
              <p class="nearly-ready">{{i18n
                  "zero_click_sso.admin.info.nearly_ready_prefix"
                }}
                {{@model.provider}}{{i18n
                  "zero_click_sso.admin.info.nearly_ready_suffix"
                }}</p>
            {{/if}}
          {{else}}
            <p class="not-ready">{{i18n
                "zero_click_sso.admin.info.not_ready"
              }}</p>
          {{/if}}
        </div>
      </div>
    </div>
  </template>
);
