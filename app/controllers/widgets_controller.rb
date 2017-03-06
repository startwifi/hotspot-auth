class WidgetsController < ApplicationController
  helpers WidgetsHelper

  get '/widgets' do
    @company = current_user.company
    case current_user.provider
    when 'facebook' then widget_facebook
    when 'vkontakte' then widget_vkontakte
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

  def widget_vkontakte
    case @company.vk.action
    when 'post'
      haml :'widgets/vkontakte/post', layout: :'layouts/social'
    when 'join'
      render_vkontakte_join
    when 'auth'
      redirect to('/vkontakte/auth')
    end
  end

  def render_facebook_join
    if is_member?(:facebook, @company.fb.group_id)
      redirect to('/facebook/joined')
    else
      haml :'widgets/facebook/join', locals: { facebook: true }, layout: :'layouts/social'
    end
  end

  def render_vkontakte_join
    if is_member?(:vkontakte, @company.vk.group_id)
      redirect to('/vkontakte/joined')
    else
      haml :'widgets/vkontakte/join', locals: { vkontakte: true }, layout: :'layouts/social'
    end
  end
end
