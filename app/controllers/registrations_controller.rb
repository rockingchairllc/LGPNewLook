class RegistrationsController < Devise::RegistrationsController
  def new
      super
  end
  
  def create
       
       check_zip = Zipcode.find_by_codes(params[:user][:zip])
       
        unless check_zip.nil?
          super
        else
          
          futurecity = Futurecitydemand.create(:email=> params[:user][:email], :zipcode => params[:user][:zip])
          Futurecitymailer.deliver_future_city_email(futurecity)
          
          redirect_to("/thank-you")
        end
  end
  
  def update
      super
  end
  
  protected

  def after_sign_up_path_for(resource)
    '/user/dashboard/signup/2'
  end
  
  
end