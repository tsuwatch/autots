require 'ayaneru/server'
require 'ayaneru/niconico'
require 'redis'

module Ayaneru
	def self.niconico
		@niconico ||= Niconico.instance
	end

	def self.redis
		@redis ||= Redis.connect
		@redis.client.reconnect unless @redis.client.connected?
		@redis
	end
end
