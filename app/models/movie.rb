class Movie < ActiveRecord::Base
  def self.all_ratings
     all = self.all
     ratings = all(:select=>"rating",:group=>"rating").map(&:rating)
  end
end
