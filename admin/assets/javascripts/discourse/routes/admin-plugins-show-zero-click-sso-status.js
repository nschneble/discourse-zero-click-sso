import Route from "@ember/routing/route";
import { ajax } from "discourse/lib/ajax";

export default class AdminPluginsShowZeroClickSsoStatusRoute extends Route {
  async model() {
    return ajax("/zero-click-sso/status.json");
  }
}
