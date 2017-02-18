class User < ActiveRecord::Base
  belongs_to :company

  validates :name, :provider, :uid, :company, presence: true
end
