class MainController < ApplicationController
  def home
  end

  # data format
  # {
  #  "photo" : FILE,
  #  "message" : TEXT,
  #  "metadata" : '[{
  #     "point" : NUMBER
  #     "head" : [X, Y],
  #     "eyes" : [X, Y, WIDTH, HEIGHT]
  #   },
  #   ...
  #  ]'
  # }
  def upload
    face = Face.new(params[:face])

    if face.save
      metadata = JSON.parse(face.metadata)

      require 'face-converter'
      metadata = metadata.sort {|m| m["point"]}
      metadata.each_with_index do |f, i|
      end

      render :json => {"face" => {"id" => face.id, "message" => face.message, "photo_url" => face.photo.url}}
    else
      render :status => 500, :json => {"msg" => "얼굴 인식에 실패했습니다. #CANNOT_CONVERT"}
    end
  end

  # OAUTH
  def oauth_with_facebook
    # init
    callback_url = "#{request.protocol}#{request.host_with_port}#{share_with_facebook_path(params[:face_id])}"
    @oauth = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET, callback_url)

    # request
    redirect_to @oauth.url_for_oauth_code(:permissions => "publish_stream")
  end

  # SHARE
  def share_with_facebook
    # init
    callback_url = "#{request.protocol}#{request.host_with_port}#{share_with_facebook_path(params[:face_id])}"
    @oauth = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET, callback_url)

    # get access token
    access_token = @oauth.get_access_token(params[:code])

    # exception
    if access_token.nil? || access_token.empty?
      flash[:error] = "페이스북에 공유하는 과정에서 문제가 발생했습니다.#GET_ACCESS_TOKEN"
      redirect_to face_path(params[:face_id])
    end
    @graph = Koala::Facebook::API.new(access_token)

    # find
    face = Face.find(params[:face_id])

    # exception
    if face.nil?
      flash[:error] = "페이스북에 공유하는 과정에서 문제가 발생했습니다.#NOT_EXIST_FACE"
      redirect_to root_path
    end

    # set data
    face_url = "#{request.protocol}#{request.host_with_port}#{face_path(params[:face_id])}"
    title = "미남이시네요"
    message = face.message + " 더 자세한 정보는 #{face_url}"
    file = face.converted_file

    # share
    @graph.put_picture(file, "image/jpeg", {:message => message, :title => title}, "me")
    redirect_to face_path(params[:face_id])
  end

  # DEMO PAGE
  def example
  end

  # ABOUT PAGE
  def about
  end
end
