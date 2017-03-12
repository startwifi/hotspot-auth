class EventsController < ApplicationController
  before do
    load_company
  end

  get '/:provider/subscribe' do
    case current_user.provider
    when 'facebook'
      current_user.add_event(:join)
      redirect to(router_url)
    when 'vkontakte'
      current_user.add_event(:join)
      redirect to(router_url)
    when 'twitter'
      twitter_client.follow(current_user.company.tw.group_name)
      current_user.add_event(:join)
      redirect to(router_url)
    end
  end

  get '/:provider/post' do
    case current_user.provider
    when 'facebook'
      post_facebook
    when 'vkontakte'
      post_vkontakte
    when 'twitter'
      post_twitter
    end
  end

  get '/:provider/auth' do
    return auth_sms if current_user.provider == 'sms'
    current_user.add_event(:auth)
    redirect to(router_url)
  end

  get '/:provider/joined' do
    current_user.add_event(:member)
    redirect to(router_url)
  end

  def auth_sms
    case params[:provider]
    when 'sms_ident_auth'
      return current_user.add_event(:auth) if session[:sms_auth_success].present?
      current_user.add_event(:sms_ident)
    when 'sms_ident'
      current_user.add_event(:sms_ident)
    when 'sms_ident_adv'
      current_user.add_event(:sms_ident_adv)
    end
    redirect to(router_url)
  end

  def post_facebook
    FacebookPostService.new(current_user.company, session[:user_token], params).call
    current_user.add_event(:post)
    redirect to(router_url)
  rescue Koala::Facebook::ClientError => e
    flash[:alert] = e.message
    redirect to('/failure')
  end

  def post_vkontakte
    VkPhotoUploadService.new(current_user.company, session[:user_token]).call
    current_user.add_event(:photo)
    redirect to(router_url)
  rescue
    redirect to('/')
  end

  def post_twitter
    if @company.tw.post_image?
      twitter_client.update_with_media(@company.tw.post_text, File.new(twitter_image))
    else
      twitter_client.update(@company.tw.post_text)
    end
    current_user.add_event(:post)
    redirect to(router_url)
  end

  private

  def load_company
    @company = current_user.company
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = @company.tw.api_key.present? ? @company.tw.api_key : ENV['TWITTER_KEY']
      config.consumer_secret = @company.tw.api_secret.present? ? @company.tw.api_secret : ENV['TWITTER_SECRET']
      config.access_token = session[:user_token]
      config.access_token_secret = session[:user_secret]
    end
  end

  def twitter_image
    open("/tmp/#{@company.tw.post_image}", 'wb') do |file|
      file << open(@company.tw.post_image_url).read
    end
  end
end
