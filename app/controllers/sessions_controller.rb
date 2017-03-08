class SessionsController < ApplicationController
  before '/:provider/setup' do
    load_company
  end

  before '/:provider/callback' do
    load_company
    load_user
  end

  OmniAuth.configure do |config|
    config.path_prefix = nil
  end

  use OmniAuth::Builder do
    provider :facebook, setup: true,
      scope: 'public_profile, user_birthday, user_likes, publish_actions, email',
      info_fields: 'birthday, name, link, gender, email'
    provider :instagram,
      setup: true,
      scope: 'likes comments relationships'
    provider :twitter,
      setup: true
    provider :vkontakte,
      setup: true,
      scope: 'email, photos'
  end

  get '/:provider/callback' do
    return render_404 unless @company && @user
    save_access_token
    save_statistics
    session[:user_id] = @user.id
    redirect to('/widgets')
  end

  get '/failure' do
    flash[:alert] = "Authentication error: #{params[:message]}"
    redirect to('/')
  end

  get '/:provider/setup' do
    api_credentials = OmniauthSetupService.new(@company, params[:provider]).call
    request.env['omniauth.strategy'].options.merge!(api_credentials)
  end

  private

  def load_company
    @company = Company.find_by(token: session[:company_token])
    render_404 unless @company
  end

  def load_user
    @user = CreateWithOmniauthService.new(@company, request.env['omniauth.auth']).call
  end

  def save_statistics
    StatisticService.new(@user, request).call
  end

  def credentials
    @credentials ||= request.env['omniauth.auth']['credentials']
  end

  def save_access_token
    case @user.provider
    when 'facebook'
      session[:user_token] = credentials['token']
    when 'twitter'
      session[:user_token] = credentials['token']
      session[:user_secret] = credentials['secret']
    when 'odnoklassniki'
      session[:user_token] = credentials['refresh_token']
    when 'vkontakte'
      session[:user_token] = credentials['token']
    end
  end
end
