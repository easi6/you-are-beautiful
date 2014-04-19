class Face < ActiveRecord::Base
  has_attached_file :photo, :styles => {:converted => "700x500>"}

  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  def converted_photo
    File.open("#{File.dirname(self.photo.path)}/../converted/#{self.photo_file_name}") 
  end
end
