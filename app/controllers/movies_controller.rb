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
    
    redirect=false #a boolean variable for deciding whether a redirection is required or not
    @all_ratings= Movie.all_ratings 
    
    #if(!session[:ratings])
    #  session[:ratings]=@all_ratings
    #end
    
    # code for storing the session related to the sort feature
    if (params[:sort_by])
      session[:sort_by]=params[:sort_by]
    else
      params[:sort_by]=session[:sort_by]
      redirect=true
    end
    
   
    @sort_by=params[:sort_by]||session[:sort_by]
  

    # code for storing the session related to the rating selection feature
    if params[:ratings]
      session[:ratings]=params[:ratings]
    else
      params[:ratings]=session[:ratings]
      redirect=true
    end
    
    #code for redirecting 
    if redirect
      flash.keep
      redirect_to:sort_by=>params[:sort_by]||session[:sort_by], :ratings=>params[:ratings]||session[:ratings]||all_ratings
    end
    
    @checks=@all_ratings
    if params[:ratings] || session[:ratings]
      @checks= params[:ratings].keys || session[:ratings].keys
    end
    
    @movies = Movie.order(params[:sort_by]).where(rating: @checks)
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
