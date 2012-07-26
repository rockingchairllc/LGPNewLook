class Users::ProfilesController < UsersController

  def index
    @user=User.find(current_user.id)
    @movies=Movie.all.sort_by! { |m| m.title }

    @param_movie_id=params[:movie]
    @param_movie_id=nil if @param_movie_id=='0'
    @param_miles=(params[:miles] || 20)
    @param_zip=(params[:zip] || @user.zipcode)

    @users=User.near_watchlists(@user,@param_zip,@param_miles,@param_movie_id)

    @other_users=User.near_no_watchlists(@user,@param_zip,@param_miles)

  end

  def show
    @user=User.find(params[:id])
    if @user.id == current_user.id
      redirect_to edit_users_profile_path(current_user.id)
    end
  end

  def edit
    @user=User.find(params[:id])
    @questions=Question.find_all_by_active(true)
    unless @user.id == current_user.id
      redirect_to user_profile_path(current_user.id)
    end
  end

  # controller to handle user profile updates.
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

    if params[:user]['birthdate(1i)'] && !params[:user]['birthdate(1i)'].blank?
      @user.birthdate=Date.new(params[:user]['birthdate(1i)'].to_i,params[:user]['birthdate(2i)'].to_i,params[:user]['birthdate(3i)'].to_i)
    else
      @user.errors[:birthdate] << 'is required.'
    end

    if @user.errors.count == 0
      @user.save
      redirect_to edit_users_profile_path(@user.id)
    else
      @questions=Question.find_all_by_active(true)
      render :edit
    end

  end


end