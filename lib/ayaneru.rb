require 'ayaneru/server'
require 'ayaneru/niconico'
require 'twitter'
require 'redis'
require 'dotenv'

Dotenv.load
module Ayaneru
  def self.niconico
    @niconico ||= Niconico.instance
  end

  def self.redis
    @redis ||= Redis.connect(
      host: ENV['REDIS_HOST'] || Redis::Client::DEFAULTS[:host],
      port: ENV['REDIS_PORT'] || Redis::Client::DEFAULTS[:port]
    )
    @redis.client.reconnect unless @redis.client.connected?
    @redis
  end

  def self.twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end
end
