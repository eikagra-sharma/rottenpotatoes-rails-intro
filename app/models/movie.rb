class Movie < ActiveRecord::Base
    def self.all_ratings
        return {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
    end
end
