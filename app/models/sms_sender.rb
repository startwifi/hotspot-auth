class SmsSender
  include ActiveModel::Model

  attr_accessor :phone

  validates_plausible_phone :phone, presence: true, with: /\A\+\d+/

  def send_sms(code)
    smsc_client.send_sms(phone, "Your password: #{code}")
  end

  private

  def smsc_client
    Smsc::Client.new do |client|
      client.login = ENV['SMSC_LOGIN']
      client.password = ENV['SMSC_PASSWORD']
    end 
  end
end
