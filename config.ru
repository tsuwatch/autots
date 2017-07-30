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
        response = Ayaneru.niconico.search(tag, 1)
        response.each do |r|
          begin
            ret = Ayaneru.niconico.reserve(r.contentId)
          rescue => exception
            puts exception.message
            begin
              Ayaneru.twitter.direct_message_create(Ayaneru.twitter.user.screen_name, "これ以上タイムシフト予約できません．『#{r.title}』（#{r.url}）")
            rescue => exception
              puts exception.message
            end
          end
          begin
            Ayaneru.twitter.direct_message_create(Ayaneru.twitter.user.screen_name, "『#{r.title}』（#{r.url}）をタイムシフト予約しました．") if ret
          rescue => exception
            puts exception.message
          end
        end
      end
      yesterday = today
    end
    sleep 60*60*1
  end
end
