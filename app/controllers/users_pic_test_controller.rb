class UsersPicTestController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @new_image=@user.user_images.new
  end

  def create
    @user = User.find(params[:user_id])

    @new_image=@user.user_images.new(params[:user_image])

    logger.debug ":::::: pic :::: " + @new_image.inspect

    if @new_image.is_profile_pic
      @user.user_images.each do |ui|
        (ui.is_profile_pic=false; ui.save) if ui.id && ui.is_profile_pic
      end
    end
    if @user.save
      redirect_to users_path
    else
      render :new
    end

  end

end