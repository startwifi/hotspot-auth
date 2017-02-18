class Company < ActiveRecord::Base
  has_many :users
  has_many :events
  has_many :statistics
  has_many :devices
  has_one :network
  has_one :vk
  has_one :fb
  has_one :tw
  has_one :in
  has_one :ok
  has_one :sms
  has_one :guest
end
