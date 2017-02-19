module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def make_link(link, dst, mac)
    "#{link}?username=T-#{mac}&dst=#{dst}"
  end

  def router_url
    link = current_user ? destination_link : session[:dst]
    make_link(session[:link], link, session[:mac])
  end

  def destination_link
    provider = case current_user.provider
               when 'vkontakte' then 'vk'
               when 'facebook' then 'fb'
               when 'twitter' then 'tw'
               when 'instagram' then 'in'
               when 'odnoklassniki' then 'ok'
               when 'sms' then 'sms'
               when 'guest' then 'guest'
               else
                 current_user.provider
               end

    provider_class = current_user.company.send(provider)
    if provider_class && provider_class&.link_redirect?
      provider_class.link_redirect
    else
      session[:dst]
    end
  end

  def render_404
    halt 404
  end

  def t(*args)
    I18n.t(*args)
  end

  def mac_address(mac)
    mac.gsub('%3A',':')
  end
end
