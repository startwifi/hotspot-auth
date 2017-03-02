class Company < ActiveRecord::Base
  has_many :devices
  has_many :events
  has_many :users
  has_many :statistics

  has_one :fb
  has_one :guest
  has_one :in
  has_one :ok
  has_one :sms
  has_one :tw
  has_one :vk
end
