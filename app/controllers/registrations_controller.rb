class RegistrationsController < Devise::RegistrationsController
  def new
      @user = User.new
      @user.username='elarson120120'
      @user.user_images.build
  end
  
  def create
    @user = User.new(params[:user])
     respond_to do |format|
       if @user.save
         format.html { redirect_to '/registration/step2' }
       else
         format.html { render action: "new" }
       end
     end
       # check_zip = Zipcode.find_by_codes(params[:user][:zip])
       #       
       #        unless check_zip.nil?
       #          super
       #        else
       #          
       #          futurecity = Futurecitydemand.create(:email=> params[:user][:email], :zipcode => params[:user][:zip])
       #          Futurecitymailer.deliver_future_city_email(futurecity)
       #          
       #          redirect_to("/thank-you")
       #        end
  end
  
  def step2
    
  end
  
  def update
      super
  end
  
  protected

  def after_sign_up_path_for(resource)
    '/user/dashboard/signup/2'
  end
  
  
end