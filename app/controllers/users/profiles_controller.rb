class Users::ProfilesController < UsersController

  def index
    @users=User.all
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

end