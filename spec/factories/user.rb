# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user do
    login      "john"
    first_name "John"
    last_name  "Doe"
    email      "john.doe@gmail.com"
    active     true
    password   "myverysecretpassword"
    profiles   { [FactoryGirl.create(:profile)] }
  end
end
