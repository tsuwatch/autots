module Ayaneru
	class Niconico
		def reserve(lv)
			login unless @logined
			lv = lv.sub(/^lv/, "")
			ulck = get_ulck(lv)
		  do_reservation(lv, ulck)
      true
		end

		def get_ulck(lv)
			login unless @logined

			query = {
				'mode' => 'watch_num',
				'vid' => lv,
				'token' => "watch_modal_0_official_lv#{lv}_comingsoon"
			}
			response = Ayaneru.niconico.agent.get(URL[:reserve], query)
      raise UlckParseError, 'It is the limit of the number of your reservation' unless response.at('div.reserve')
			response.at('div.reserve').inner_html.scan(/ulck_[0-9]+/)[0]
		end

		def do_reservation(lv, ulck)
			login unless @logined

			post_data = {
				'mode' => 'regist',
				'vid' => lv,
				'token' => ulck,
				'_' => ''
			}

			Ayaneru.niconico.agent.post(URL[:reserve], post_data)
		end
	end
  class UlckParseError < StandardError; end
end

