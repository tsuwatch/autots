require 'mechanize'
require 'singleton'

module Ayaneru
	class Niconico
		include Singleton
		URL = {
			login: 'https://secure.nicovideo.jp/secure/login?site=niconico',
			search: 'http://api.search.nicovideo.jp/api/'
		}

		attr_reader :agent, :logined

		def initialize
			YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/account.yml').each do |sym, value|
				instance_variable_set('@' + sym, value)
			end

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

require_relative 'niconico/search'
