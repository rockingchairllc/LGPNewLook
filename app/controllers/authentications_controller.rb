class AuthenticationsController < ApplicationController

  # handle callbacks from APIs
    #  from FB: 2 params: signed_request and provider
    # this could be for a new user or an existing user
  def create

    # test -- dev IDs hard-coded
    #client = FBGraph::Client.new(:client_id => '374526839255198',:secret_id =>'7449426519ece5238bd4730bc7ff2a36')

    provider=params[:provider]
    # TODO:  if you add other providers on this same callback url, you will need to add to this for proper parsing of the callback data

    if provider=='facebook'
      ret=FBGraph::Canvas.parse_signed_request(LGPConfiguration.facebook_secret, params[:signed_request])
      logger.debug ret
      # user logged in example:
      # {"algorithm"=>"HMAC-SHA256",
      #  "code"=>"2.AQDsr6JEWk-r5yC2.3600.1335114000.1-618164289|1k8Wv8R8JId5tWEi1nGQ3gVp1Qg",
      #  "issued_at"=>1335108526,
      #  "user_id"=>"618164289"}

      # registration example:
      #{"algorithm"=>"HMAC-SHA256",
      # "expires"=>1335056400,
      # "issued_at"=>1335051493,
      # "oauth_token"=>"AAAFUoVM2cJ4BAGHBVlEGU6VgjnFG5eubUAbLqqNv2CxuD5UxaAxatY2pYrb7i4syRQWSFm7dGhWJqNf6XpCxITZApWoRhzoCH5BtLHAZDZD",
      # "registration"=>{
      #   "name"=>"Matt Pestritto",
      #   "birthday"=>"03/02/1980",
      #   "gender"=>"male",
      #   "location"=>{"name"=>"New York, New York", "id"=>108424279189115},
      #   "email"=>"matt@pestritto.com"},
      # "registration_metadata"=>{"fields"=>"name,birthday,gender,location,email"},
      # "user"=>{"country"=>"us", "locale"=>"en_US"},
      # "user_id"=>"618164289"
      #}


      # user should have an account...
      if params[:access_token]
        # get user_id from signed_request
        provider_user_id=ret['user_id']
        provider_auth_id=params[:access_token]
        auth=Authentication.find_by_provider_and_provider_user_id(provider,provider_user_id)
        unless auth
          return render :json => { :success=> false, :errors=>['user provider id not found'] }
        end
        if auth.provider_auth_id!=provider_auth_id
          auth.provider_auth_id=provider_auth_id
          auth.save
        end
        # user could already be logged in
        unless current_user
          sign_in(:user, auth.user)
        end

        respond_to do |format|
          format.html { redirect_to after_sign_in_path_for(auth.user) }
          format.json { render :json => { :success=>true, :redirect=> after_sign_in_path_for(auth.user) } }
        end
        return

      end


      if ret['registration']
        # pull out data from the call back data
        email=ret['registration']['email']
        gender=ret['registration']['gender']
        orientation=ret['registration']['orientation']
        birthday=ret['registration']['birthday']
        zip_code=ret['registration']['zip_code']
        password=ret['registration']['password']

        full_name=ret['registration']['name']
        first_name=full_name.split(' ').first
        # this isn't used...
        last_name=full_name.split(' ').last


        provider_user_id=ret['user_id']
        provider_auth_id=ret['oauth_token']

        # determine if new / existing user
        u=User.find_by_email(email)
        unless u
          # new user
          u=User.new(:email=>email, :firstname=>first_name, :gender=>gender, :orientation=>orientation,:birthdate=>birthday, :zipcode=>zip_code, :password=>password, :password_confirmation=>password)
        else
          # existing user -- update params
          u.firstname=first_name
          u.gender=gender
          u.orientation=orientation
          u.birthdate=birthday
          u.zipcode=zip_code
          u.password=password
          u.password_confirmation=password
        end

        # save user record -- updating or creating the user record
        if u.save

          # create the authentication record -- if it exists or update the record ( could have expired )
          if !provider_user_id.blank? && !provider_auth_id.blank?
            auth=u.authentications.find_by_provider_and_provider_user_id(provider,provider_user_id)
            if auth==nil # no auth id -- create it
              auth=u.authentications.create(:provider=>provider, :provider_user_id=>provider_user_id, :provider_auth_id=>provider_auth_id )
              logger.debug 'created new auth record'
            elsif auth.provider_auth_id!=provider_auth_id # user's auth ID changed -- update it
              auth.provider_auth_id=provider_auth_id
              auth.save
              logger.debug 'updated existing auth record'
            else # match -- app already authorized.
              # do nothing for now...
              # sign-in will process below below
            end
          end

          unless current_user
            sign_in(:user, u)
          end

          respond_to do |format|
            format.html { redirect_to after_sign_in_path_for(u) }
            format.json { render :json => { :success=>true, :redirect=> after_sign_in_path_for(u) } }
          end
          return

        else
          # something went wrong ... how to handle this ???
           # should never happen -- probably bad code or unhandled exception / validation.
           # notify system administrator
          logger.debug 'ERRORS SAVING USER: ' + u.inspect
          logger.debug 'ERRORS SAVING USER: ' + u.errors.inspect
        end
      end
    end
    render :json=>{ :success=> false, :errors=>['unknown action']}
  end
end