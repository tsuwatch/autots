require 'json'

module Ayaneru
  class Niconico
    def search(tag, until_days)
      client = Nicosa::Services::Live.new(user_agent: 'https://github.com/tsuwatch/autots')
      client.search(
        tag,
        {
          targets: 'tagsExact',
          _sort: '+startTime',
          filters: [
            providerType: ['official'],
            startTime: {
              gte: Time.now.iso8601,
              lt: Time.at(Time.now.to_i + until_days * 24 * 60 * 60).iso8601
            }
          ]
        }
      )
    end
  end
end
