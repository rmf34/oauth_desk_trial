# -*- coding: utf-8 -*-
FactoryGirl.define do
  sequence :user_email do |n|
    "desk_test_user-#{n}@test.test"
  end

  factory :user do
    email { generate(:user_email) }
    password 'password'
    # association :authentiction, :factory => :authentication, :strategy => :build
  end
end
