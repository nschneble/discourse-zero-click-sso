export default {
  resource: "admin.adminPlugins.show",
  path: "/plugins",
  map() {
    this.route("zero-click-sso-status", { path: "/status" });
  },
};
