class WidgetsController < ApplicationController
  get '/widgets' do
    @company = current_user.company
    case current_user.provider
    when 'facebook' then widget_facebook
    end
  end

  private

  def widget_facebook
    case @company.fb.action
    when 'post'
      haml :'widgets/facebook/post', layout: :'layouts/social'
    when 'join'
      render_facebook_join
    when 'auth'
      redirect to('/facebook/auth')
    end
  end

  def render_facebook_join
    if is_member?('fb', @company.fb.group_id)
      redirect to('/facebook/is_member')
    else
      haml :'widgets/facebook/join', locals: { facebook: true }, layout: :'layouts/social'
    end
  end

  def is_member?(social, group)
    case social
    when 'fb'
      graph = Koala::Facebook::API.new(session[:user_token])
      graph.get_connections('me', "likes/#{group}").any?
    end
  end
end
