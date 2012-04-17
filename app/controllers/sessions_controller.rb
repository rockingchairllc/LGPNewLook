class SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.html { super }
      format.json {
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
        sign_in(resource_name, resource)
        return render :json => {:success => true, :redirect => after_sign_in_path_for(resource)}
      }
    end
  end

  def failure
    msg='Invalid email or password.'
    return render :json => {:success => false, :error => msg }
  end

end
