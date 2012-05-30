class AuthenticationsController < ApplicationController

  def show
    provider=params[:provider]
    fb_auth = FbGraph::Auth.new(LGPConfiguration.facebook_app_id, LGPConfiguration.facebook_secret)
    client = fb_auth.client
    client.redirect_uri = "http://" + request.host_with_port + "/auth/facebook/callback/"
    redirect_to client.authorization_uri(:scope => [:email,:user_photos,:user_birthday,:user_interests,:user_relationship_details,:publish_actions])
  end

  # handle callbacks from APIs
  # this could be for a new user or an existing user
  def create

    # if you add other providers on this same callback url, you will need to add to this for proper parsing of the callback data
    provider=params[:provider]

    if provider=='facebook'

      #FbGraph.debug!
      #FbGraph.logger = Rails.logger

      fb_auth = FbGraph::Auth.new(LGPConfiguration.facebook_app_id, LGPConfiguration.facebook_secret)
      client = fb_auth.client
      client.redirect_uri = "http://" + request.host_with_port + "/auth/facebook/callback/"
      client.authorization_code = params[:code]
      access_token = client.access_token!(:client_auth_body)
      #logger.debug 'ACCESS_TOKEN::::' + access_token.inspect
      fb_user=FbGraph::User.me(access_token).fetch
      logger.debug fb_user.inspect

      # get user_id from signed_request
      provider_user_id=fb_user.identifier
      provider_auth_id=fb_user.access_token.to_s
      auth=Authentication.find_by_provider_and_provider_user_id(provider,provider_user_id)
      unless auth

        user=User.find_by_email(fb_user.email)

        unless user

          # recheck for valid invite code
           #  this is the only spot a new user gets created....
          unless (cookies[:invite_code])
            redirect_to root_path(:error=>'invalid-invite')
            return
            #return render :json => { :success=>false, :errors=>['invalid invite code'] }
          end
          invite_code=InviteCode.find_by_code(cookies[:invite_code])
          unless invite_code
            redirect_to root_path(:error=>'invalid-invite')
            return
            #return render :json => { :success=>false, :errors=>['invalid invite code'] }
          end
          # clear invite code cookie ---
          cookies[:invite_code]=nil

          # logic for orientation
          orientation=nil
          if fb_user.interested_in.length==1
            if fb_user.interested_in.first=='female' && fb_user.gender == 'male'
              orientation='straight'
            elsif fb_user.interested_in.first=='female' && fb_user.gender=='female'
              orientation='gay'
            elsif fb_user.interested_in.first=='male' && fb_user.gender=='female'
              orientation='straight'
            elsif fb_user.interested_in.first=='male' && fb_user.gender=='male'
              orientation='gay'
            end
          elsif fb_user.interested_in.length > 1
            orientation='bi'
          end

          # impossible password
          t=Time.now
          user=User.create(:email=>fb_user.email, :firstname=>fb_user.first_name, :gender=>fb_user.gender, :orientation=>orientation, :birthdate=>fb_user.birthday, :password=>t.hash, :password_confirmation=>t.hash)
          user.invite_code=invite_code

          # use default picture from fb url
          photo=user.user_images.new()
          if (fb_user.picture)
            photo.picture_from_url(fb_user.picture('large'))
          else
            f=File.open(Rails.root.join('app','assets','images','bw_popcorn_kernel.jpg'))
            photo.photo=f
          end

          photo.is_profile_pic=true

          user.save
        end

        auth=user.authentications.create(:provider=>provider, :provider_user_id=>provider_user_id, :provider_auth_id=>provider_auth_id)

      end

      # if auth id updated
      if auth.provider_auth_id!=provider_auth_id
        auth.provider_auth_id=provider_auth_id
        auth.save
      end

      # user could already be logged in
      unless current_user
        sign_in(:user, auth.user)
      end

      respond_to do |format|
        format.html { return redirect_to after_sign_in_path_for(auth.user) }
        format.json { return render :json => { :success=>true, :redirect=> after_sign_in_path_for(auth.user) } }
      end

    end
    render :json=>{ :success=> false, :errors=>['unknown provider']}
  end
end