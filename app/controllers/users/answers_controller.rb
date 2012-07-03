class Users::AnswersController < UsersController

  def create

  end

  def update
    a=Answer.find(params[:id])

    # security -- check user
    unless a.user_id == current_user.id
      render :json => { :success=>false, :errors=>['unauthorized']}
      return
    end

    if a.update_attributes(params[:answer])
      render :json => { :success=> true }
    else
      render :json => { :success=> false, :errors=>a.errors.to_json }
    end

  end

end