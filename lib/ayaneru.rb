require 'ayaneru/server'
require 'ayaneru/niconico'

module Ayaneru
	def self.niconico
		@niconico = Niconico.instance
	end
end
