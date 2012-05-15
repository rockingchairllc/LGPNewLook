class Users::DashboardsController < UsersController

  def index
    @user=User.find(current_user.id)
  end

  # processes second registration step for user
  def update
    @user=User.find(params[:id])

    # security check
    unless @user.id==current_user.id
      @user.errors[:firstname] << 'you do not have permission to do this'
      return
    end

    # fields we are allowed to update, with custom errors if not present...
    if params[:user][:firstname] && !params[:user][:firstname].blank?
      @user.firstname=params[:user][:firstname]
    else
      @user.errors[:firstname] << 'is required.'
    end

    if params[:user][:gender] && !params[:user][:gender].blank?
      @user.gender=params[:user][:gender]
    else
      @user.errors[:gender] << 'is required.'
    end

    if params[:user][:orientation] && !params[:user][:orientation].blank?
      @user.orientation=params[:user][:orientation]
    else
      @user.errors[:orientation] << 'is required.'
    end

    if params[:user][:zipcode] && !params[:user][:zipcode].blank?
      @user.zipcode=params[:user][:zipcode]
    else
      @user.errors[:zipcode] << 'is required.'
    end

    if params[:user][:profile_pic] && !params[:user][:zipcode].blank?
      @user.user_images.each do |ui|
        if ui.is_profile_pic
          ui.is_profile_pic=false
          ui.save
        end
      end
      @user.user_images.new(:photo=>params[:user][:profile_pic], :is_profile_pic=>true)
    end

    if params[:user]['birthdate(1i)'] && !params[:user]['birthdate(1i)'].blank?
      @user.birthdate=Date.new(params[:user]['birthdate(1i)'].to_i,params[:user]['birthdate(2i)'].to_i,params[:user]['birthdate(3i)'].to_i)
    else
      @user.errors[:birthdate] << 'is required.'
    end

    @user.save if @user.errors.count == 0
    render :index

  end

end