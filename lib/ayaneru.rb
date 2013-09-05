require 'ayaneru/server'
require 'ayaneru/niconico'
require 'twitter'
require 'redis'

module Ayaneru
	def self.niconico
		@niconico ||= Niconico.instance
	end

	def self.redis
		@redis ||= Redis.connect
		@redis.client.reconnect unless @redis.client.connected?
		@redis
	end

	def self.twitter
		YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/ayaneru/twitter_account.yml').each do |sym, value|
				instance_variable_set('@' + sym, value)
		end

		@twitter ||= Twitter::Client.new(
			:consumer_key => @consumer_key,
			:consumer_secret => @consumer_secret,
			:oauth_token => @oauth_token,
			:oauth_token_secret => @oauth_token_secret
		)
	end
end
