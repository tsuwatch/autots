require 'sinatra/base'
require 'haml'
require 'twitter'

module Ayaneru
	class Server < Sinatra::Base
		get '/' do
			haml :index
		end

		get '/schedule' do
			@registered_tags = Ayaneru.redis.lrange "tags", 0, -1
			@results = {}
			@registered_tags.each do |tag|
				r = Ayaneru.niconico.search(tag, 7).to_s.split("\n")
				@results[tag] = JSON.parse(r[2])
			end

			haml :schedule
		end

		post '/schedule' do
			Ayaneru.redis.rpush "tags", params[:tag]
			redirect '/schedule'
		end

		get '/reserve' do
			YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/twitter_account.yml').each do |sym, value|
				instance_variable_set('@' + sym, value)
			end

			@twitter = Twitter::Client.new(
				:consumer_key => @consumer_key,
				:consumer_secret => @consumer_secret,
				:oauth_token => @oauth_token,
				:oauth_token_secret => @oauth_token_secret
			)

			@registered_tags = Ayaneru.redis.lrange "tags", 0, -1
			@registered_tags.each do |tag|
				r = Ayaneru.niconico.search(tag, 1).to_s.split("\n")
				@results = JSON.parse(r[2])
				if @results["values"]
					@results["values"].each do |value|
						Ayaneru.niconico.reserve(value['cmsid'])
						@twitter.update "@tsuwatch 「#{value['title']}」（http://live.nicovideo.jp/watch/#{value['cmsid']}）をタイムシフト予約しました．"
					end
				end
			end

			:ok
		end

		post '/delete' do
			Ayaneru.redis.lrem "tags", 1, params[:tag]
			redirect '/schedule'
		end
	end
end
