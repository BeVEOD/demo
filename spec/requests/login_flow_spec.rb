# -*- encoding : utf-8 -*-
require "spec_helper"

describe "login flow" do
  it "should login and request the originally requested page" do
    puts current_url
    visit "/system_settings"
    page.status_code.should == 200
  end
end
