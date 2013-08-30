$:.unshift File.expand_path('../lib', __FILE__)

require 'ayaneru'
run Ayaneru::Server
