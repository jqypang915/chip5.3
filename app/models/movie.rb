class Movie < ActiveRecord::Base
  
  def self.all_ratings
    Movie.select(:rating)
  end
  
  def self.with_ratings(ratings)
    if ratings == nil
      Movie.all
    else 
      Movie.where(rating: ratings.keys)
    end
  end
  

  
end
