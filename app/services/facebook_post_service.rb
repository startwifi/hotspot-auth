class FacebookPostService
  def initialize(company, token, params)
    @company = company
    @graph = Koala::Facebook::API.new(token)
    @post = params[:post_text]
  end

  def call
    @graph.put_wall_post(@post, prepare_data)
  end

  private

  def prepare_data
    {
      link: @company.fb.post_link,
      description: @company.fb.post_text,
      picture: @company.fb.post_image_url
    }
  end
end
