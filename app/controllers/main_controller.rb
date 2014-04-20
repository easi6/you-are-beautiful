class MainController < ApplicationController
  def home
    @face = Face.new
  end

  def en
    @face = Face.new
    @faces = Face.all.order("created_at desc")
  end

  # data format
  # {
  #  "photo" : FILE,
  #  "message" : TEXT,
  #  "metadata" : '[{
  #     "point" : NUMBER
  #     "position" : [[X, Y], ...]
  #   },
  #   ...
  #  ]'
  # }
  def upload
    #face = Face.new(params[:face])
    face = Face.new
    face.message = params[:face][:message]
    face.photo = params[:face][:photo]
    face.metadata = params[:face][:metadata]

    require 'face-converter'
    if face.save && FaceConverter.convert(face.photo.path, face.metadata)
      #render :json => {"face" => {"id" => face.id, "message" => face.message, "photo_url" => face.photo.url(:converted)}}
      redirect_to face_path(face.id)
    else
      #render :status => 500, :json => {"msg" => "얼굴 인식에 실패했습니다. #CANNOT_CONVERT"}
      flash[:error] = "얼굴 인식에 실패했습니다.#CANNOT_CONVERT"
      redirect_to example_path
    end
  end

  def upload_en
    #face = Face.new(params[:face])
    face = Face.new
    face.message = params[:face][:message]
    face.photo = params[:face][:photo]
    face.metadata = params[:face][:metadata]

    require 'face-converter'
    if face.save && FaceConverter.convert(face.photo.path, face.metadata)
      #render :json => {"face" => {"id" => face.id, "message" => face.message, "photo_url" => face.photo.url(:converted)}}
      redirect_to en_path
    else
      #render :status => 500, :json => {"msg" => "얼굴 인식에 실패했습니다. #CANNOT_CONVERT"}
      flash[:error] = "얼굴 인식에 실패했습니다.#CANNOT_CONVERT"
      redirect_to en_path
    end
  end

  def show_face
    @face = Face.find(params[:face_id])
    if @face.nil?
      flash[:error] = "존재하지 않는 이미지입니다.#NOT_EXIST_FACE"
      redirect_to example_path
    end
  end

  # OAUTH
  def oauth_with_facebook
    # find
    face = Face.find(params[:face_id])

    # exception
    if face.nil?
      flash[:error] = "페이스북에 공유하는 과정에서 문제가 발생했습니다.#NOT_EXIST_FACE"
      redirect_to example_path
      return
    end

    # update exception
    unless face.update_attribute(:message, params[:face][:message])
      flash[:error] = "페이스북에 공유하는 과정에서 문제가 발생했습니다.#CANNOT_UPDATE_FACE"
      redirect_to example_path
      return
    end

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
      return
    end
    @graph = Koala::Facebook::API.new(access_token)

    # find
    face = Face.find(params[:face_id])

    # exception
    if face.nil?
      flash[:error] = "페이스북에 공유하는 과정에서 문제가 발생했습니다.#NOT_EXIST_FACE"
      redirect_to example_path
      return
    end

    # set data
    face_url = "#{request.protocol}#{request.host_with_port}#{face_path(params[:face_id])}"
    title = "미남이시네요"
    message = face.message + " 더 자세한 정보는 #{face_url}"
    file = face.converted_photo

    # share
    @graph.put_picture(file, "image/jpeg", {:message => message, :title => title}, "me")
    flash[:msg] = "페이스북에 사진이 공유되었습니다."
    redirect_to face_path(params[:face_id])
    return
  end

  # DEMO PAGE
  def example
    @face = Face.new
  end

  # ABOUT PAGE
  def about
  end
end
