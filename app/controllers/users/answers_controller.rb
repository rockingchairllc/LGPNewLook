class Users::AnswersController < UsersController

  def create
    a=Answer.new(params[:answer])

    # security -- check user
    unless a.user_id == current_user.id
      render :json => { :success=>false, :errors=>['unauthorized']}
      return
    end

    if a.response.blank?
      render :json => { :success=> true, :question_id=>a.question_id, :new_response=>'' }
    else
      if a.save
        render :json => { :success=> true, :question_id=>a.question_id, :new_response=>a.response }
      else
        render :json => { :success=> false, :errors=>a.errors.to_json }
      end
    end


  end

  def update
    a=Answer.find(params[:id])

    # security -- check user
    unless a.user_id == current_user.id
      render :json => { :success=>false, :errors=>['unauthorized']}
      return
    end

    if params[:answer][:response].blank?
      qid=a.question_id
      a.destroy
      render :json => { :success=> true, :question_id=>qid, :new_response=>'' }
    else
      if a.update_attributes(params[:answer])
        render :json => { :success=> true, :question_id=>a.question_id, :new_response=>a.response }
      else
        render :json => { :success=> false, :errors=>a.errors.to_json }
      end
    end


  end

end