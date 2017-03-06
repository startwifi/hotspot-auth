require 'open-uri'

class VkPhotoUploadService
  def initialize(company, token)
    @company = company
    @token = token
  end

  def call
    upload_photo
  end

  private

  def upload_photo
    query = JSON.parse(RestClient.post(upload_url, file1: File.new(image)))
    photo_params = {
      access_token: @token,
      album_id: album_id,
      server: query['server'],
      photos_list: query['photos_list'],
      hash: query['hash'],
      # latitude: 48.461758,
      # longitude: 35.012707,
      caption: @company.vk.post_text
    }
    vk_request('save', photo_params)
  end

  def album_id
    query = vk_request('getAlbums', access_token: @token)
    if query['response'][0]['title'].eql?(@company.name)
      query['response'][0]['aid']
    else
      query = vk_request('createAlbum', album_params)
      query['response']['aid']
    end
  end

  def album_params
    {
      title: @company.name,
      description: @company.vk.post_text,
      access_token: @token
    }
  end

  def upload_url
    url_params = { access_token: @token, album_id: album_id }
    query = vk_request('getUploadServer', url_params)
    query['response']['upload_url']
  end

  def image
    open("/tmp/#{@company.vk.post_image}", 'wb') do |file|
      file << open(@company.vk.post_image_url).read
    end
  end

  def vk_request(method, params)
    vk_request = RestClient.post("https://api.vk.com/method/photos.#{method}", params)
    JSON.parse(vk_request)
  end
end
