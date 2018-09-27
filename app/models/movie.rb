class Movie < ActiveRecord::Base
    def self.all_ratings
        rating_array = Movie.pluck('DISTINCT rating')
        Hash[rating_array.collect { |rating| [rating, 1] } ]
    end
end
