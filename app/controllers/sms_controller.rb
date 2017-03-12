class SmsController < ApplicationController
  before do
    load_company
  end

  get '/sms/authorize' do
    @sms = SmsSender.new
    haml :'sms/index'
  end

  post '/sms/send' do
    @sms = SmsSender.new(params)

    if @sms.valid?
      session[:otp_secret] ||= ROTP::Base32.random_base32
      session[:otp_counter] ||= 0
      session[:otp_phone] = @sms.phone

      # Start generate OTP password
      session[:otp_counter] += 1 # Increment counter

      hotp = ROTP::HOTP.new(session[:otp_secret])
      code = hotp.at(session[:otp_counter])

      @sms.send_sms(code)
      flash[:notice] = t('sms.success', phone: @sms.phone)
      redirect to('/sms/validate')
    else
      haml :'sms/index'
    end
  end

  get '/sms/validate' do
    haml :'sms/validate'
  end

  post '/sms/validate' do
    hotp = ROTP::HOTP.new(session[:otp_secret])

    if hotp.verify(params[:code], session[:otp_counter])
      if @company.sms.action.eql?('ident_auth') && session[:sms_auth_success].present?
        redirect to('/sms/auth')
      end
      redirect to('/sms/callback')
    else
      flash[:alert] = t(:errors)
      haml :'sms/validate'
    end
  end

  private

  def load_company
    @company = Company.find_by(token: session[:company_token])
    if @company.nil? || @company.sms.action == 'disabled'
      redirect to('/')
    end
  end
end
