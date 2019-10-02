class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] || session[:sort]
    #Ratings that are selected
    @checked_ratings = params[:ratings] || session[:ratings] ||
      Hash[MoviesHelper.all_ratings.map {|k| [k, true]}]
    #ALL ratings
    @all_ratings = Hash[MoviesHelper.all_ratings.map {|k| [k, @checked_ratings.key?(k)]}]
    # Remembers the session - did this in Part 2. Didn't realize this would be
    # part of Part 3 when I looked into doing the checkboxes and updating the list based on them.
    # So I had already used [session] for the sort and ratings.
    session[:sort] = @sort
    session[:ratings] = @checked_ratings
    if !params[:sort] && !params[:ratings]
      flash.keep
      redirect_to movies_path(:ratings => @checked_ratings, :sort => @sort) and return
    end
    @movies = Movie.where(:rating => @checked_ratings.keys).order @sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

