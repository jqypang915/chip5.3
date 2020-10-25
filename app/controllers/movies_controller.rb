class MoviesController < ApplicationController

    before_action :parameters_set_index,  only: [:index]
  
  

  
  
    def parameters_set_index
    # If it was a Refresh Request    
    if (!params[:commit].blank?)
      
      if (params[:ratings].nil?)
        session.clear
        redirect_to movies_path({:sort => session[:sort], :ratings => {"G" => 1,"PG" => 1,"PG-13" => 1,"R" => 1}})
      end
      
      
    else    
      # if it was not a refresh request (aka back from description) then set all the values to whatever it was originally
      if (params[:sort].nil? && !session[:sort].nil? || params[:ratings].nil? && !session[:ratings].nil?)
       redirect_to movies_path({:sort => params[:sort] || session[:sort], :ratings => params[:ratings] || session[:ratings]})
      end
    end
  end
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = ['G','PG','PG-13','R']
    @title_class = "hilite"
    @date_class = "hilite"
    
    @ratings_to_show = params[:ratings] 
    @sort = params[:sort]

    
    session[:ratings] = @ratings_to_show
    session[:sort] = @sort

   
    @movies = Movie.with_ratings(@ratings_to_show)
    
  
    if @sort == "title"
      @movies = @movies.order(:title)
      @title_class = "hilite bg-warning"
    end
      
    if @sort == "date"
      @movies = @movies.order(:release_date)
      @date_class = "hilite bg-warning"
    end
    
    

    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
