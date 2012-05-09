class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def index

    @user=User.find(current_user.id)

    # solo profile pic photo
    @profile_pic=@user.profile_pic

    # other photos
    @photos=@user.user_images.find_all_by_is_profile_pic(false)

    logger.debug @photos.inspect

    @new_photo=UserImage.new(:user_id=>@user.id)

  end

  # post for new photo upload
  def create

    @user = User.find(current_user.id)

    @new_photo=@user.user_images.new(params[:user_image])

    logger.debug ":::::: pic :::: " + @new_photo.inspect

    if @new_photo.is_profile_pic
      @user.user_images.each do |ui|
        (ui.is_profile_pic=false; ui.save) if ui.id && ui.is_profile_pic
      end
    end

    if @user.save
      @new_photo=UserImage.new(:user_id=>@user.id)
    end

    @profile_pic=@user.profile_pic
    @photos=@user.user_images.find_all_by_is_profile_pic(false)

    render :index

  end

  # used for setting specific image to 'is_profile_pic'
  def update

    @user = User.find(current_user.id)

    @photo=@user.user_images.find(params[:id])

    # hook into these actions
    if params[:user_image][:action]=='make_profile_picture'
      # turn off all the other ones.
      @user.user_images.each do |ui|
        (ui.is_profile_pic=false; ui.save) if ui.id && ui.is_profile_pic
      end

      @photo.is_profile_pic=true
      @photo.save
    end

    @profile_pic=@user.profile_pic
    @photos=@user.user_images.find_all_by_is_profile_pic(false)
    @new_photo=UserImage.new(:user_id=>@user.id)

    render :index

  end

  # for deleting photos
  def destroy
    @user = User.find(current_user.id)

    @photo=@user.user_images.find(params[:id])

    @photo.destroy

    @profile_pic=@user.profile_pic
    @photos=@user.user_images.find_all_by_is_profile_pic(false)
    @new_photo=UserImage.new(:user_id=>@user.id)

    render :index

  end

end

