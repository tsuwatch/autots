$:.unshift File.expand_path('../lib', __FILE__)

require 'eventmachine'
require 'json'
require 'ayaneru'

run Ayaneru::Server

EM::defer do
	yesterday = Time.now.day - 1
	loop do
		today = Time.now.day
		if today != yesterday
			registered_tags = Ayaneru.redis.lrange 'tags', 0, -1
			registered_tags.each do |tag|
				r = Ayaneru.niconico.search(tag, 1).to_s.split("\n")
				results = JSON.parse(r[2])
				if results['values']
					results['values'].each do |value|
						Ayaneru.niconico.reserve(value["cmsid"])
						Ayaneru.twitter.update "@tsuwatch 『#{value['title']}』（http://live.nicovideo.jp/watch/#{value['cmsid']}）をタイムシフト予約しました．"
					end
				end
			end

		end
		yesterday = today
	end
end
