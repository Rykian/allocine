module Allocine
  
  class Search < MovieList
    attr_reader :query, :options
    
    # Initialize a new Allocine search with the specified query
    #
    #   search = Allocine::Search.new("Superman")
    #
    def initialize(query, options = {})
      @query = query
      @options = options
    end
    
    # Returns an array of Allocine::Movie objects for easy search result yielded.
    def movies
      @movies ||= parse_movies
    end

    private
    def document
      @document ||= Allocine::Search.query(@query, @options)
    end
    
    def self.query(query, options = {})
      options[:q] = query
      url = Allocine::Helper.build_url("search", options)
      body = Allocine::Helper.get_body(url)
      JSON.parse(body)["feed"] rescue nil
    end
        
    
  end
end
