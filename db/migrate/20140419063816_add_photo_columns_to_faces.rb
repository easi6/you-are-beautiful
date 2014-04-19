class AddPhotoColumnsToFaces < ActiveRecord::Migration
  def self.up
    add_attachment :faces, :photo
  end

  def self.down
    remove_attachment :faces, :photo
  end
end
