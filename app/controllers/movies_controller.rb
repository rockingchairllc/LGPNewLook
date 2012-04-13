class MoviesController < ApplicationController

  def index
    # old index page -- commented out to try new view
    # @movies = Movie.all

    # new code for movies list that will limit to zip radius
    # TODO: remove didn't want to mess with having to be logged in ( login process is not working )
    #@user = User.find(current_user.id)
    @user=User.first

    @watch_list=@user.watch_lists

    @param_miles=params[:miles]
    @param_miles=20 unless @param_miles

    @param_zip=params[:zip] || @user.zipcode

    # TODO: handle error for non-integer param
    @zip=ZipLoc.find_by_zip(@param_zip.to_i)

    unless @zip
      # TODO: handle case with no zip code found...
      @zip=ZipLoc.first
    end

    logger.debug('Zipcode: ' + @zip.inspect)

    # TODO: sanitize SQL - susceptible to sql injection
    s_function='miles_between_lat_long(' + @zip.lat.to_s + ',' + @zip.lng.to_s + ',theaters.latitude,theaters.longitude)'
    logger.debug('s_function: ' + s_function)

    # this is just to check distance functions returning from db.
    debug=false
    if (debug)
      @closest_theaters = Theater.all(:select=>'id, ' + s_function + ' as dist', :conditions => s_function+ '<' + @param_miles)

      logger.debug('Theater count:' + @closest_theaters.count.to_s)

      logger.debug(@closest_theaters.inspect)
      logger.debug('distance:' + @closest_theaters.first.dist)

      @closest_theaters.sort_by! { |theater| theater.dist }
      logger.debug('sorted: ' + @closest_theaters.inspect)
      logger.debug('distance:' + @closest_theaters.first.dist)

      theater_array=nil
      @closest_theaters.each do |t|
        if theater_array
          theater_array=theater_array+','+t.id.to_s
        else
          theater_array=t.id.to_s
        end
      end
      logger.debug('closest theater_array:' + theater_array)
    end


    # trying final combined query
    @movies=Movie.all(:include=>[:theaters], :joins=>[:theaters], :conditions=> s_function + '<' + @param_miles, :order=>s_function)

    # debug checking...
    if (debug)
      @movies.each do |m|
        logger.debug('playing in ' + m.theaters.length.to_s + ' theaters. order by closest: ' + theater_ids)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  
  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end
end
