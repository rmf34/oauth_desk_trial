# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :authentication do
    association :user, :factory => :user, :strategy => :build
    provider 'desk'
    uid rand(99999999)
    token SecureRandom.hex[0..19]
    secret (SecureRandom.hex[0..19] + SecureRandom.hex[0..19])
    site 'https://rmf34.desk.com'
  end
end
