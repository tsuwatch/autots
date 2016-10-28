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
    @redis ||= Redis.connect
    @redis.client.reconnect unless @redis.client.connected?
    @redis
  end

  def self.twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
      config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
    end
  end
end
