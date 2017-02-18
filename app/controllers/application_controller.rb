class ApplicationController < Sinatra::Base
  configure do
    enable :reloader
    enable :sessions

    set :logging, true
    set :database_file, 'config/database.yml'
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, 'secret'

    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, '../../config/locales', '*.yml')]
    I18n.backend.load_translations
  end

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def render_404
      haml :not_found
    end

    def t(*args)
      I18n.t(*args)
    end

    def mac_address(mac)
      mac.gsub('%3A',':')
    end
  end
end
