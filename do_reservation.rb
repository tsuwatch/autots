require 'redis'
require 'mechanize'
require 'json'

agent = Mechanize.new
redis = Redis.connect

tags = redis.lrange "tags", 0, -1

for tag in tags do
	post_data = {}
	data_filters = Array.new

	today = Time.now
	until_days = 1

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
		"field" => "provider_type",
		"type" => "equal",
		"value" => "official"
	}
	data_filters[3] = {
		"field" => "start_time",
		"from" => Time.local(today.year, today.month, today.day, 0, 0, 0).strftime("%Y-%m-%d %H:%M:%S"),
		"include_lower" => true,
		"include_upper" => true,
		"to" => Time.local(today.year, today.month, today.day + until_days, 23, 59, 59).strftime("%Y-%m-%d %H:%M:%S"),
		"type" => "range"
	}
	data_filters[4] = {
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

	response = agent.post('http://api.search.nicovideo.jp/api/', JSON.pretty_generate(post_data))
	results = response.body.to_s.split("\n")
	live_data = JSON.parse(results[2])

	if live_data['values']
		for data in live_data['values']
			post_data = {
				'lv' => data['cmsid']
			}
			agent.post('localhost:9292/reserve', post_data)
		end
	end
end
