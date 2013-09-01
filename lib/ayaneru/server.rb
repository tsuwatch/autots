require 'sinatra/base'
require 'haml'

module Ayaneru
	class Server < Sinatra::Base
		get '/' do
			haml :index
		end

		get '/schedule' do
			@registered_tags = Ayaneru.redis.lrange "tags", 0, -1
			result = Ayaneru.niconico.search.to_s.split("\n")
			@json = JSON.parse(result[2])
			haml :schedule
		end

		post '/schedule' do
			Ayaneru.redis.rpush "tags", params[:tag]
			redirect '/schedule'
		end
	end
end
