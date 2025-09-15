# frozen_string_literal: true

RSpec.describe "Zero-Click SSO", type: :system do
  fab!(:user) { Fabricate(:user) }

  before do
    SiteSetting.enable_local_logins = false
    SiteSetting.zero_click_sso_enabled = true

    # pretends we've got exactly one SSO provider configured
    allow(Discourse).to receive(:enabled_authenticators).and_return([OmniAuth::Strategies::OpenIDConnect.new(nil, {})])
  end

  it "does nothing when a user is already logged in" do
    sign_in(user)
    visit "/"

    expect(page).to have_current_path("/")
  end

  # TODO/FIXME: add better tests
end
