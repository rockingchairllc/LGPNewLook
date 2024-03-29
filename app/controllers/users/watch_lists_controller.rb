class Users::WatchListsController < UsersController

  # only implemented json handler
  def create
    uid=params[:user_id]
    movie_id=params[:movie_id]
    optional_note=params[:optional_note]
    watch_list_theaters=[]
    watch_list_theaters=params[:watch_list_theaters] if params[:watch_list_theaters]

    logger.debug(watch_list_theaters.include?("10"))

    # security - user can't add a movie to another user's watchlist
    unless current_user.id == uid.to_i
      render :json => { :success => false, :errors=>['not authorized'] }
      return
    end

    wl=WatchList.find_by_user_id_and_movie_id(uid,movie_id);
    wl.note = optional_note if wl

    wl=WatchList.new(:user_id=>uid, :movie_id=>movie_id, :note=>optional_note) unless wl

    respond_to do |format|
      format.html { # no implementation -- create view if needed
      }
      format.json {
        if wl.save
          wl.watch_list_preferred_theaters.each do |wlp|
            wlp.destroy unless watch_list_theaters.include?(wlp.theater_id.to_s)
          end
          watch_list_theaters.each do |theater_id|
            wl.watch_list_preferred_theaters.create(:theater_id=>theater_id)
          end

          render :json => { :success => true }
          return
        else
          render :json => {:success => false, :errors=>wl.errors }
          return
        end
      }
      end
  end

  def destroy
    uid=params[:user_id]
    movie_id=params[:movie_id]

    # TODO: same comment as above for security

    # make sure the watchlist item exists.
    wl=WatchList.find_by_user_id_and_movie_id(uid,movie_id)
    unless wl
      respond_to do |format|
        format.html { }
        format.json {
          render :json => { :success => false, :errors=>['not found'] }
          return
        }
      end
    end

    respond_to do |format|
      format.html { }
      format.json {
        if wl.destroy
          render :json => { :success => true }
          return
        else
          render :json => {:success => false, :errors=>wl.errors }
          return
        end
      }
    end

  end
end