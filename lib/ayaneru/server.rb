require 'sinatra/base'
require 'tilt/haml'

module Ayaneru
  class Server < Sinatra::Base

    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == ENV['BASIC_USERNAME'] and password == ENV['BASIC_PASSWORD']
    end

    set :bind, '0.0.0.0'

    get '/' do
      @registered_tags = Ayaneru.redis.lrange 'tags', 0, -1
      @results = {}
      @registered_tags.each do |tag|
        @results[tag] = []
        Ayaneru.niconico.search(tag, 7).each do |r|
          @results[tag] << r
        end
      end

      haml :index
    end

    post '/' do
      Ayaneru.redis.rpush "tags", params[:tag]
      redirect '/'
    end

    post '/delete' do
      Ayaneru.redis.lrem "tags", 1, params[:tag]
      redirect '/'
    end
  end
end
