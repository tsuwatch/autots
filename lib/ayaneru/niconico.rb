require 'mechanize'

module Ayaneru
	class Niconico
		URL = {
			login: 'https://secure.nicovideo.jp/secure/login?site=niconico'
		}

		attr_reader :agent, :logined

		def initialize(mail, password)
			@mail = mail
			@password = password

			@logined = false

			@agent = Mechanize.new
			@agent.ssl_version = 'SSLv3'
		end

		def login
			page = @agent.post(URL[:login], 'mail' => @mail, 'password' => @password)
			@logined = true
		end
	end
end
