import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "zero-click-sso-admin-plugin-configuration-nav",

  initialize(owner) {
    const currentUser = owner.lookup("service:current-user");
    if (!currentUser?.admin) return;

    withPluginApi("1.33.0", (api) => {
      api.addAdminPluginConfigurationNav("zero-click-sso", [
        {
          label: "zero_click_sso.status",
          route: "adminPlugins.show.zero-click-sso-status"
        }
      ]);
    });
  }
};
