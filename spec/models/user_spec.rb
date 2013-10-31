# -*- encoding : utf-8 -*-
require "spec_helper"

describe User do
  it "orders by last name" do
    # Create profiles
    faveod_user = FactoryGirl.create(:profile)
    logged_in   = FactoryGirl.create(:profile, :name => "Logged In")

    # Create users
    olivia = FactoryGirl.create(:user, {
      :email      => "olivia.dunham@fbi.com",
      :login      => "olivia",
      :first_name => "Olivia",
      :last_name  => "Dunham",
      :password   => "fauxlivia",
      :active     => true,
      :profiles   => [logged_in]
    })
    peter = FactoryGirl.create(:user, {
      :email      => "peter.bishop@fbi.com",
      :login      => "peter",
      :first_name => "Peter",
      :last_name  => "Bishop",
      :password   => "walterson",
      :active     => true,
      :profiles   => [faveod_user, logged_in]
    })

    expect(User.order("last_name ASC")).to eq([peter, olivia])
  end
end
