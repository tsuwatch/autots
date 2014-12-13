require 'sinatra/base'
require 'haml'
require 'dotenv'

module Ayaneru
  class Server < Sinatra::Base

    Dotenv.load
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == ENV['USERNAME'] and password == ENV['PASSWORD']
    end

    get '/' do
      haml :index
    end

    get '/schedule' do
      @registered_tags = Ayaneru.redis.lrange 'tags', 0, -1
      @results = {}
      @registered_tags.each do |tag|
        chunks = Ayaneru.niconico.search(tag, 7).to_s.split("\n")
        chunks.each do |chunk|
          row = JSON.parse(chunk)
          next if !(row.has_value?('hits') and row.key?('values'))
          @results[tag] = row
          break
        end
      end

      haml :schedule
    end

    post '/schedule' do
      Ayaneru.redis.rpush "tags", params[:tag]
      redirect '/schedule'
    end

    post '/delete' do
      Ayaneru.redis.lrem "tags", 1, params[:tag]
      redirect '/schedule'
    end
  end
end
