class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    should_redirect = false
    @all_ratings = Movie.all_ratings 
    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      should_redirect = true
    else
      @ratings = {}
      Movie.all_ratings.each do |rating|
        @ratings[rating]=1
      end
      should_redirect = true
    end

    if params[:sort]
      @sort = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      should_redirect = true
    end
    if should_redirect
      redirect_to movies_path(:ratings=>@ratings, :sort=>@sort)
    end
    @movies = [] 
    Movie.all(:order=>@sort ? @sort : :id).each do |movie|
      if @ratings.keys.include?(movie[:rating]) 
        @movies.append(movie)
      end
    end
    session[:ratings] = @ratings
    session[:sort] = @sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
