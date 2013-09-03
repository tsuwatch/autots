require 'singleton'
require 'twitter'


module Ayaneru
	class Twitter
		include Singleton
		attr_reader :twitter

		def initialize
			YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/twitter_account.yml').each do |sym, value|
				instance_variable_set('@' + sym, value)
			end

			@twitter = Twitter::Client.new(
				:consumer_key => @consumer_key,
				:consumer_secret => @consumer_secret,
				:oauth_token => @oauth_token,
				:oauth_token_secret => @oauth_token_secret
			)
		end
	end
end

