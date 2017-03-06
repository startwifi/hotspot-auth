class OmniauthSetupService
  def initialize(company, provider)
    @company = company
    @provider = provider
    @api = {}
  end

  def call
    prepare_credentials
    omniauth_credentials
  end

  private

  def omniauth_credentials
    case @provider
    when 'twitter'
      {
        consumer_key: @api[:key],
        consumer_secret: @api[:secret]
      }
    when 'odnoklassniki'
      default_params.merge(
        public_key: @api[:public],
        redirect_uri: ENV['OK_REDIRECT_URI']
      )
    else
      default_params
    end
  end

  def default_params
    {
      client_id: @api[:key],
      client_secret: @api[:secret]
    }
  end

  def prepare_credentials
    case @provider
    when 'facebook'
      @api[:key] = @company.fb.api_key.present? ? @company.fb.api_key : ENV['FACEBOOK_KEY']
      @api[:secret] = @company.fb.api_secret.present? ? @company.fb.api_secret : ENV['FACEBOOK_SECRET']
    when 'vkontakte'
      @api[:key] = @company.vk.api_key.present? ? @company.vk.api_key : ENV['VK_KEY']
      @api[:secret] = @company.vk.api_secret.present? ? @company.vk.api_secret : ENV['VK_SECRET']
    when 'twitter'
      @api[:key] = @company.tw.api_key.present? ? @company.tw.api_key : ENV['TWITTER_KEY']
      @api[:secret] = @company.tw.api_secret.present? ? @company.tw.api_secret : ENV['TWITTER_SECRET']
    when 'instagram'
      @api[:key] = @company.in.api_key.present? ? @company.in.api_key : ENV['INSTAGRAM_KEY']
      @api[:secret] = @company.in.api_secret.present? ? @company.in.api_secret : ENV['INSTAGRAM_SECRET']
    when 'odnoklassniki'
      @api[:key] = @company.ok.api_key.present? ? @company.ok.api_key : ENV['OK_KEY']
      @api[:secret] = @company.ok.api_secret.present? ? @company.ok.api_secret : ENV['OK_SECRET']
      @api[:public] = @company.ok.api_public.present? ? @company.ok.api_public : ENV['OK_PUBLIC']
    end
  end
end
