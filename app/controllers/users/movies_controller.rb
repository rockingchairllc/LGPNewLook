class Users::MoviesController < UsersController

  def index
    @user=User.find(current_user.id)
    @watch_list=@user.watch_lists

    @param_miles=params[:miles] || 20
    @param_zip=params[:zip] || @user.zipcode

    # TODO: handle error for non-integer param

    # @movies=@zip.movies_and_theaters_near_zip(@param_miles)
    # commented out the version using ZipLoc (above) and opted for Movie Class method instead
    @movies = Movie.near(@param_zip, @param_miles, nil)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { 'movies' => @movies.to_json(:include => [:theaters ]) } }
    end
  end

  def show
    if params[:miles] && params[:zip]
      @movie = Movie.near(params[:zip], params[:miles], params[:id]).first
    else
      @movie = Movie.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie.to_json(:include=>[:theaters]) }
    end
  end

end