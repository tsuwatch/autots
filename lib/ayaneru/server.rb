require 'sinatra/base'
require 'haml'

module Ayaneru
	class Server < Sinatra::Base
		get '/' do
			haml :index
		end
	end
end
