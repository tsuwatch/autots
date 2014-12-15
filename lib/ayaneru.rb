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
    @twitter ||= Twitter::Client.new(
      :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
      :oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TWITTER_OAUTH_TOKEN_SECRET']
    )
  end
end
