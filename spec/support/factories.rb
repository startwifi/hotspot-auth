FactoryGirl.define do
  factory :company do
    name "Club Inc"
    owner_name "Cool owner"
    token "j4g2gs92sg3"
    phone "123 45 67"
    address "Dnz"
  end
end

FactoryGirl.define do
  factory :event do
    user
    action "login"
  end
end

FactoryGirl.define do
  factory :fb do
    company
    group_id "1234567890"
    group_name { Faker::Lorem.word }
    action "auth"
    link_redirect { Faker::Internet.domain_name }
    post_text { Faker::Lorem.sentence }
    post_link { Faker::Internet.url }

    factory :fb_with_image do
      post_image { Rack::Test::UploadedFile.new("#{settings.root}/spec/support/uploads/startwifi.png", 'image/png') }
    end
  end
end

FactoryGirl.define do
  factory :statistic do
    user
    company
    provider "Facebook"
    platform "Mac"
    platform_version "10.11"
    browser "Safari"
    browser_version "10"
    mac { Faker::Internet.mac_address }
  end
end

FactoryGirl.define do
  factory :user do
    name "Example User"
    provider "facebook"
    uid "12345678"
    company
  end
end

FactoryGirl.define do
  factory :sms do
    company
    action 'ident'
    link_redirect { Faker::Internet.domain_name }
    wall_head { Faker::Lorem.word }
    wall_text { Faker::Lorem.sentence }
    adv false

    factory :sms_with_image do
      wall_image { Rack::Test::UploadedFile.new("#{settings.root}/spec/support/uploads/startwifi.png", 'image/png') }
    end
  end
end
