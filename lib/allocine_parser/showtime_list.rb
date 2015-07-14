module Allocine
  class ShowtimeList

    def self.search_by(options = {})
      unless options[:theaters].nil?
        options[:theaters] = options[:theaters].join(',')
      end

      url = Allocine::Helper.build_url('showtimelist', options)
      JSON.parse(Allocine::Helper.get_body(url))
    end
  end
end
