require 'mechanize'
require 'singleton'

module Ayaneru
	class Niconico
		include Singleton
		URL = {
			login: 'https://secure.nicovideo.jp/secure/login?site=niconico',
			search: 'http://api.search.nicovideo.jp/api/',
			reserve: 'http://live.nicovideo.jp/api/watchingreservation'
		}

		attr_reader :agent, :logined

		def initialize
			YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/niconico_account.yml').each do |sym, value|
				instance_variable_set('@' + sym, value)
			end

			@logined = false

			@agent = Mechanize.new
			@agent.ssl_version = 'TLSv1'
		end

		def login
			page = @agent.post(URL[:login], 'mail' => @mail, 'password' => @password)

			raise LoginError, "Failed to login (x-niconico-authflag is 0)" if page.header["x-niconico-authflag"] == '0'
			@logined = true
		end

    def logout
      Ayaneru.niconico.agent.cookie_jar.clear!
      @logined = false
    end
	end
	class LoginError < StandardError; end
end

require_relative 'niconico/search'
require_relative 'niconico/reserve'
