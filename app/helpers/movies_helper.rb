module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def self.all_ratings
    ['G','PG','PG-13','R']
  end
end

