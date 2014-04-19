require_relative "../lib/face-converter"

X=0
Y=1

file_name = "/Users/tantara/Workspace/fb/imagemagick/people.jpg"

metadata = []

point = 100
position = [[0, 0]] * 70
position[33][X] = 245
position[21][Y] = 216
metadata << {"point" => point, "position" => position}

point = 30
position = [[0, 0]] * 70
position[62][X] = 243
position[62][Y] = 234
metadata << {"point" => point, "position" => position}

point = 60
position = [[0, 0]] * 70
position[33][X] = 245
position[21][Y] = 216
metadata << {"point" => point, "position" => position}

puts metadata.to_json

#FaceConverter.convert(file_name, metadata.to_json)
