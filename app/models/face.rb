class Face < ActiveRecord::Base
  has_attached_file :photo

  def converted_photo
    File.open(self.photo_file_name)
  end
end
