require 'json'
require 'fileutils'

module FaceConverter
  IMAGE=1
  COLOR_BOX=2
  X=0
  Y=1
  UGLY_EYE=0
  UGLY_SMILE=1
  UGLY_MASK=2
  MARKER_IMAGE_DIR="#{Rails.root.join("imagemagick")}"
  #MARKER_IMAGE_DIR="/Users/tantara/Workspace/fb/imagemagick"
  BEAUTIFUL_IMGAES=[
    {"type" => IMAGE, "name" => "beautiful-0.png", "width" => 100, "height" => 64},
    {"type" => IMAGE, "name" => "beautiful-1.png", "width" => 100, "height" => 71},
    {"type" => IMAGE, "name" => "beautiful-2.png", "width" => 100, "height" => 74},
    {"type" => IMAGE, "name" => "beautiful-3.png", "width" => 100, "height" => 94}
  ]
  UGLY_IMAGES=[
    {"type" => IMAGE, "sub_type" => UGLY_EYE, "name" => "ugly-0.png", "width" => 60, "height" => 10},
    {"type" => IMAGE, "sub_type" => UGLY_SMILE, "name" => "ugly-1.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "sub_type" => UGLY_MASK, "name" => "ugly-2.png", "width" => 80, "height" => 80}
  ]
  LABEL_IMAGES=[
    {"type" => IMAGE, "name" => "label-0.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "name" => "label-1.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "name" => "label-2.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "name" => "label-3.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "name" => "label-4.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "name" => "label-5.png", "width" => 50, "height" => 50},
    {"type" => IMAGE, "name" => "label-6.png", "width" => 50, "height" => 50}
  ]

  def self.convert(file_name, metadata_str)
    result = "#{File.dirname(file_name)}/../converted/#{File.basename(file_name)}"

    puts metadata_str
    metadata = JSON.parse(metadata_str)
    metadata = metadata.sort {|x, y| y["point"] <=> x["point"]}

    begin
      metadata.each_with_index do |m, i|
        img = {"type" => COLOR_BOX, "name" => "", "width" => 30, "height" => 30} # default group marker
        if i == 0 # beautiful
          img = BEAUTIFUL_IMGAES[rand(BEAUTIFUL_IMGAES.length)]
        elsif i == metadata.length - 1 # ugly
          img = UGLY_IMAGES[rand(UGLY_IMAGES.length)]
        else
          img = LABEL_IMAGES[rand(LABEL_IMAGES.length)]
        end

        merged = "#{MARKER_IMAGE_DIR}/#{img["name"]}"
        position = m["position"]
        puts "position #{position}"
        ### crown
        #x: 33.x - img.width / 2
        #y: 21.y - img.height
        #width: img.width
        #height: img.height

        ### mask
        #x: 0.x
        #y: 21.y
        #width: 13.x - 1.x
        #height: (7.y - 62.y) * 2
        
        ### smile
        #x: 62.x - img.width / 2
        #y: 62.y - img.height / 2
        #width: img.width
        #height: img.height

        ### eye
        #x: 0.x
        #y: 33.y
        #width: 14.x - 0.x
        #height: 41.y - 33.y
        
        ### label
        #x: 33.x - img.width / 2
        #y: 21.y - img.height
        #width: img.width
        #height: img.height
        
        if i == 0 # beautiful
          x = "+#{position[33][X] - img["width"] / 2}"
          y = "+#{position[21][Y] - img["height"]}"
          size = "#{img["width"]}x#{img["height"]}"
        elsif i == metadata.length - 1 # ugly
          case img["sub_type"]
          when UGLY_EYE
            x = "+#{position[0][X]}"
            y = "+#{position[33][Y]}"
            size = "#{position[14][X] - position[0][X]}x#{position[41][Y] - position[33][Y]}"
          when UGLY_SMILE
            x = "+#{position[62][X] - img["width"] / 2}"
            y = "+#{position[62][Y] - img["height"] / 2}"
            size = "#{img["width"]}x#{img["height"]}"
          when UGLY_MASK
            x = "+#{position[0][X]}"
            y = "+#{position[21][Y]}"
            size = "#{position[13][X] - position[1][X]}x#{(position[7][Y] - position[62][Y]) / 2}"
          end
        else
          x = "+#{position[33][X] - img["width"] / 2}"
          y = "+#{position[21][Y] - img["height"] * 1.5}"
          size = "#{img["width"]}x#{img["height"]}"
        end

        #puts "composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}"
        `composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`
      end
      return true
    rescue
      return false
    end
  end
end
