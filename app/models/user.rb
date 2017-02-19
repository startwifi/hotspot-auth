class User < ActiveRecord::Base
  belongs_to :company

  has_many :events, dependent: :destroy
  has_many :statistics, dependent: :destroy
  has_many :devices

  validates :name, :provider, :uid, :company, presence: true

  def add_event(action)
    events.create!(action: action, provider: self.provider, company: self.company)
  end
end
