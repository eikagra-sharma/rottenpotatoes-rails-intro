class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # Reference: https://github.com/danielhex/rottenpotatoes/blob/master/app/controllers/movies_controller.rb
  def index
    if(!params.key?(:sort) && !params.key?(:ratings))
      if(session.key?(:sort) || session.key?(:ratings))
        sort_by = session[:sort]
        @ratings_dict = session[:ratings]
      end
    end
    @sort = params.key?(:sort) ? (session[:sort] = params[:sort]) : session[:sort]
    if params.key?(:sort)
      sort_by = params[:sort]
      session[:sort] = params[:sort]
    else
      sort_by = session[:sort]
    end
    
    @all_ratings = Movie.all_ratings.keys
    @ratings_dict = params[:ratings]
    if(@ratings_dict != nil)
      session[:ratings] = @ratings_dict
    else
      if(!params.key?(:commit) && !params.key?(:sort))
        @ratings_dict = Movie.all_ratings
        session[:ratings] = Movie.all_ratings
      else
        @ratings_dict = session[:ratings]
      end
    end
    @ratings_dict = Movie.all_ratings unless @ratings_dict != nil
    
    @movies = Movie.order(sort_by).select { |movie| @ratings_dict.key?(movie.rating) }
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
  
  def set_class(sort)
    # check same parameter to index
    params[:sort] == sort ? 'hilite' : nil
  end
  helper_method :set_class

end
