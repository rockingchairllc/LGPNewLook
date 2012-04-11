class UsersController < Devise::RegistrationsController
  
  # GET /users
  # GET /users.json
  def index
    
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @questions = Question.active

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def new
      @user = User.new
      @user.firstname='elarson120120'
      @user.user_images.build
  end
  
  def create
    @user = User.new(params[:user])
     respond_to do |format|
       if @user.save
         if params[:photo]
           ui = UserImage.new(:photo => params[:photo])
           ui.is_profile_pic=true
           ui.user_id = @user.id
           ui.save
           logger.debug ui.inspect
           logger.debug ui.errors.inspect if ui.errors
           logger.debug params[:photo].inspect
         end
         format.html { redirect_to registration_step2_path }
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