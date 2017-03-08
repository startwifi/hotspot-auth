class Tw < ActiveRecord::Base
  belongs_to :company

  def post_image_url
    return if post_image.blank?
    "#{ENV['IMAGES_HOST']}/uploads/#{self.class.name.downcase}/post_image/#{company.id}/#{post_image}"
  end
end
