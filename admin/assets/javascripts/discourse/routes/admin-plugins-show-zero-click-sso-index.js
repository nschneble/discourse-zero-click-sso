import Route from "@ember/routing/route";

export default class AdminPluginsShowZeroClickSsoIndexRoute extends Route {
  beforeModel() {
    return this.replaceWith("admin.adminPlugins.show.zero-click-sso-status");
  }
}
