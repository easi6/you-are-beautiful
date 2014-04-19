class CreateFaces < ActiveRecord::Migration
  def change
    create_table :faces do |t|
      t.text :message, :default => ""
      t.text :metadata, :default => ""

      t.timestamps
    end
  end
end
