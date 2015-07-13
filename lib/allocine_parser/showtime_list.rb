module Allocine
  class ShowtimeList

    def self.search_by(options = {})
      url = Allocine::Helper.build_url('showtimelist', options)
      JSON.parse(Allocine::Helper.get_body(url))
    end
  end
end
