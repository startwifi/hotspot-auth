class EventsController < ApplicationController
  get '/:provider/subscribe' do
    case current_user.provider
    when 'fb'
      current_user.add_event(:join)
      redirect to(router_url)
    end
  end

  get '/:provider/post' do
    case params[:provider]
    when 'facebook'
      post_facebook
    end
  end

  get '/:provider/auth' do
    current_user.add_event(:auth)
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

  def is_member
    current_user.add_event(:member)
    redirect to router_url
  end

  private

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = @company.tw.api_key.present? ? @company.tw.api_key : ENV['TWITTER_KEY']
      config.consumer_secret     = @company.tw.api_secret.present? ? @company.tw.api_secret : ENV['TWITTER_SECRET']
      config.access_token        = session[:user_token]
      config.access_token_secret = session[:user_secret]
    end
  end
end
