class Movie < ActiveRecord::Base
  
  def all_ratings
    Movie.select(:ratings)
  end
  
  def self.with_ratings(ratings)
    if ratings == nil
      Movie.select(:rating)
    else 
      Movie.where(rating: ratings)
    end
  end
  

  
end
