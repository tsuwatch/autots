require 'json'

module Ayaneru
	class Niconico
		def search(tag)
			post_data = {}
			data_filters = Array.new
			data_filters[0] = {
				"field" => "ss_adult",
				"type" => "equal",
				"value" => false
			}
			data_filters[1] = {
				"field" => "live_status",
				"type" => "equal",
				"value" => "reserved"
			}
			data_filters[2] = {
				"field" => "start_time",
				"from" => "2013-09-02 00:00:00",
				"include_lower" => true,
				"include_upper" => true,
				"to" => "2013-09-02 23:59:59",
				"type" => "range"
			}
			data_filters[3] = {
				"field" => "timeshift_enabled",
				"type" => "equal",
				"value" => true
			}
			post_data["filters"] = data_filters
			post_data["from"] = 0
			post_data["issuer"] = "pc"
			post_data["join"] = [
				"cmsid",
				"title",
				"description",
				"community_id",
				"open_time",
				"start_time",
				"live_end_time",
				"view_counter",
				"comment_counter",
				"score_timeshift_reserved",
				"provider_type",
				"channel_id",
				"live_status",
				"tags",
				"member_only"
			]
			post_data["order"] = "desc"
			post_data["query"] = tag
			post_data["reason"] = "default"
			post_data["search"] = ["tags"]
			post_data["service"] = ["live"]
			post_data["size"] = 100
			post_data["sort_by"] = "_live_recent"
			post_data["timeout"] = 10000

			response = Ayaneru.niconico.agent.post(URL[:search], JSON.pretty_generate(post_data))
			response.body
		end
	end
end
