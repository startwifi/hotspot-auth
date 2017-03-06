require 'rack-flash'
require 'sinatra/activerecord'

class ApplicationController < Sinatra::Application
  configure do
    enable :reloader
    enable :sessions
    enable :logging

    use Rack::Flash

    set :logging, true
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, 'secret'

    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, '../config/locales', '*.yml')]
    I18n.config.available_locales = :en
    I18n.backend.load_translations
  end

  helpers ApplicationHelper
end
