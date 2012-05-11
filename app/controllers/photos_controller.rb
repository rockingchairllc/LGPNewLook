class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def load_fb_images
    auth=@user.authentications.find_by_provider('facebook')
    #fb_user=FbGraph::User.me(auth.provider_auth_id).fetch

    album=FbGraph::User.me(auth.provider_auth_id).albums.detect do |album|
      album.type == 'profile'
    end
    @facebook_profile_pictures = album.photos

    logger.debug @facebook_profile_pictures.inspect
  end

  def index

    @user=User.find(current_user.id)

    # solo profile pic photo
    @profile_pic=@user.profile_pic

    # other photos
    @photos=@user.user_images.all(:conditions=>'is_profile_pic is null or is_profile_pic=false')

    logger.debug @photos.inspect

    @new_photo=UserImage.new(:user_id=>@user.id)

    load_fb_images

  end

  # post for new photo upload
  def create

    @user = User.find(current_user.id)

    load_fb_images

    # facebook upload
    if params[:user_image] && params[:user_image][:action]
      if params[:user_image][:action]=='import_facebook_profile_pictures'
        logger.debug 'Processing FB Image Load'

        @facebook_profile_pictures.each do |fb_pic|
          if params[:user_image][:picture_ids].include?(fb_pic.identifier)
            logger.debug 'Loading picture --- ' + fb_pic.inspect
            photo=@user.user_images.new()
            photo.picture_from_url(fb_pic.source)
          end
        end

        @user.save

      end
        @new_photo=UserImage.new(:user_id=>@user.id)
    else

      # regular upload -- form submission
      @new_photo=@user.user_images.new(params[:user_image])

      if @new_photo.is_profile_pic
        @user.user_images.each do |ui|
          (ui.is_profile_pic=false; ui.save) if ui.id && ui.is_profile_pic
        end
      end

      if @user.save
        @new_photo=UserImage.new(:user_id=>@user.id)
      end

    end

    @profile_pic=@user.profile_pic
    @photos=@user.user_images.all(:conditions=>'is_profile_pic is null or is_profile_pic=false')

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
    @photos=@user.user_images.all(:conditions=>'is_profile_pic is null or is_profile_pic=false')
    @new_photo=UserImage.new(:user_id=>@user.id)

    load_fb_images

    render :index

  end

  # for deleting photos
  def destroy
    @user = User.find(current_user.id)

    @photo=@user.user_images.find(params[:id])

    @photo.destroy

    @profile_pic=@user.profile_pic
    @photos=@user.user_images.all(:conditions=>'is_profile_pic is null or is_profile_pic=false')
    @new_photo=UserImage.new(:user_id=>@user.id)

    load_fb_images

    render :index

  end

end

