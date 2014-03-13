class DigitalObject < ActiveRecord::Base

  belongs_to :attachable, :polymorphic => true

  # Paperclip
  has_attached_file :asset,
    :styles => { :large => '1280x1280>', :medium => '210x210>', :thumb => '130x130>' },
    :url => "#{Settings.digital_objects_host}/digital_objects/:access_token/:style.:extension",
    :default_url => "/images/missing-:style.jpg"

  # Scopes
  scope :by_entity, lambda { |entity|
    where(:attachable_type => entity) if entity.present?
  }

  # Methods

  def is_image?
    ["image/jpeg", "image/jpg", "image/pjpeg"].include?(asset.content_type)
  end

  def is_pdf?
    ["application/pdf"].include?(asset.content_type)
  end

  def is_video?
    ["video/mp4", "application/mp4", "video/mpeg4"].include?(asset.content_type)
  end

  private

  Paperclip.interpolates :access_token do |attachment, style|
    attachment.instance.access_token
  end

end

