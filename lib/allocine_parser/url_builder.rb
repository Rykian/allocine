module Allocine

  require 'digest/sha1'
  require 'base64'
  require 'cgi'

  module Helper

    ALLOCINE_PARTNER_KEY = '100043982026'
    ALLOCINE_SECRET_KEY = '29d185d98c984a359e6e6f26a0474269'
    API_URL = "http://api.allocine.fr/rest/v3"

    def Helper.build_url(method, params = {})
      params[:format] ||= "json"
      params[:partner] = ALLOCINE_PARTNER_KEY
      params[:sed] ||= DateTime.now.strftime('%Y%m%d')

      line = [:q, :code, :count, :page, :format, :partner, :sed, :zip].map do |sym|
        "#{sym}=#{params[sym]}" if params[sym]
      end.compact.join('&')

      sig = CGI::escape(Base64.encode64(Digest::SHA1.digest(ALLOCINE_SECRET_KEY + line)).chomp)

      "#{API_URL}/#{method}?#{line}&sig=#{sig}"
    end

    # Taken from api-allocine-helper.php
    def Helper.get_body(url)
      url = URI.parse(url)
      req = Net::HTTP::Get.new(url, 'User-Agent' => Helper.get_user_agent)

      ip = (1..4).map{rand(256)}.join('.')
      req.add_field('REMOTE_ADDR', ip)
      req.add_field('HTTP_X_FORWARDED_FOR', ip)

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      res.body
    end

    # Taken from api-allocine-helper.php
    def Helper.get_user_agent
      v = "%d.%d" % [rand(4) + 1, rand(9)]
      a = rand(9);
      b = rand(99);
      c = rand(999);
      user_agents = [
                     'Mozilla/5.0 (Linux; U; Android #{v}; fr-fr; Nexus One Build/FRF91) AppleWebKit/5#{b}.#{c} (KHTML, like Gecko) Version/#{a}.#{a} Mobile Safari/5#{b}.#{c}',
                     'Mozilla/5.0 (Linux; U; Android #{v}; fr-fr; Dell Streak Build/Donut AppleWebKit/5#{b}.#{c}+ (KHTML, like Gecko) Version/3.#{a}.2 Mobile Safari/ 5#{b}.#{c}.1',
                     'Mozilla/5.0 (Linux; U; Android 4.#{v}; fr-fr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30',
                     'Mozilla/5.0 (Linux; U; Android 4.#{v}; fr-fr; HTC Sensation Build/IML74K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30',
                     'Mozilla/5.0 (Linux; U; Android #{v}; en-gb) AppleWebKit/999+ (KHTML, like Gecko) Safari/9#{b}.#{a}',
                     'Mozilla/5.0 (Linux; U; Android #{v}.5; fr-fr; HTC_IncredibleS_S710e Build/GRJ#{b}) AppleWebKit/5#{b}.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/5#{b}.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; HTC Vision Build/GRI#{b}) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android #{v}.4; fr-fr; HTC Desire Build/GRJ#{b}) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; T-Mobile myTouch 3G Slide Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android #{v}.3; fr-fr; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; HTC Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/5#{b}.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; LG-LU3000 Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/5#{b}.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; HTC_DesireS_S510e Build/GRI#{a}) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/#{c}.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; HTC_DesireS_S510e Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile',
                     'Mozilla/5.0 (Linux; U; Android #{v}.3; fr-fr; HTC Desire Build/GRI#{a}) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android 2.#{v}; fr-fr; HTC Desire Build/FRF#{a}) AppleWebKit/533.1 (KHTML, like Gecko) Version/#{a}.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android #{v}; fr-lu; HTC Legend Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/#{a}.#{a} Mobile Safari/#{c}.#{a}',
                     'Mozilla/5.0 (Linux; U; Android #{v}; fr-fr; HTC_DesireHD_A9191 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
                     'Mozilla/5.0 (Linux; U; Android #{v}.1; fr-fr; HTC_DesireZ_A7#{c} Build/FRG83D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/#{c}.#{a}',
                     'Mozilla/5.0 (Linux; U; Android #{v}.1; en-gb; HTC_DesireZ_A7272 Build/FRG83D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/#{c}.1',
                     'Mozilla/5.0 (Linux; U; Android #{v}; fr-fr; LG-P5#{b} Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'
                    ]
      user_agent = user_agents[rand(user_agents.count)]
      eval("\"" + user_agent + "\"")
    end

  end
end
