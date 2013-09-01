require 'sinatra/base'
require 'haml'

module Ayaneru
	class Server < Sinatra::Base
		get '/' do
			haml :index
		end

		get '/schedule' do
			result = Ayaneru.niconico.search.to_s.split("\n")
			@json = JSON.parse(r[2])

			haml :schedule
		end
	end
end
