module Allocine

  class Season
    attr_accessor :id, :url, :season_number, :episodes

    # Represent a serie Season on Allocine website
    # s = Allocine::Season.new(12277)
    # e = s.episodes.first


    def initialize(id)
      @id = id
      @episodes = []
    end

    # Returns parent serie
    def serie
      Allocine::Serie.new(document["parentSeries"]["code"])
    end

    # Returns season number
    def season_number
      document["seasonNumber"] rescue nil
    end

    # Returns numbers of episode
    def episode_count
      document["episodeCount"] rescue nil
    end

    # Returns numbers of episode
    def episode_numbers
      document["episode"].size rescue nil
    end

    # Returns an Array of episode ids
    def episode_ids
      document["episode"].map { |episode| episode["code"]} rescue []
    end

    # Returns an Array of Allocine::Episode
    def episodes
      s = []
      episode_ids.each do |allocine_id|
        s << Allocine::Episode.new(allocine_id)
      end
      s
    end

    private

    def document
      @document ||= Allocine::Season.find_by_id(@id)
    end

    def self.find_by_id(allocine_id)
      url = Allocine::Helper.build_url("season",
                                       :code => allocine_id,
                                       :profile => "large")
      body = Allocine::Helper.get_body(url)
      JSON.parse(body)["season"]
    end

  end

end
