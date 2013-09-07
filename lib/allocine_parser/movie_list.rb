module Allocine

  class MovieList
    def movies
      @movies ||= parse_movies
    end

    private
    def parse_movies
      movies = []
      document["movie"].each do |element|
        id = element['code']
        title = element['originalTitle']
        movies << Allocine::Movie.new(id, title)
      end
      movies
    end
  end

end
