/* eslint-disable ember/no-classic-components */
import Component from "@ember/component";
import { classNames, tagName } from "@ember-decorators/component";

@tagName("div")
@classNames("above-main-container", "excitement")
export default class ExcitementConnector extends Component {
  get exclamations() {
    let excitement_level = Number(this.siteSettings?.excitement_level) || 1;
    excitement_level = Math.max(0, Math.min(excitement_level, 11));
    return "!".repeat(excitement_level);
  }

  <template>
    {{#if this.siteSettings.show_excitement}}
      <p>I'm very excited about zero click SSO auth{{this.exclamations}}</p>
    {{/if}}
  </template>
}





