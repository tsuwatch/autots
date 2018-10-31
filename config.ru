$:.unshift File.expand_path('../lib', __FILE__)

require 'json'
require 'chrono'
require 'ayaneru'

run Ayaneru::Server

Thread.new do
  Chrono::Trigger.new('* * * * *') do
    registered_tags = Ayaneru.redis.lrange 'tags', 0, -1
    registered_tags.each do |tag|
      response = Ayaneru.niconico.search(tag, 1)
      response.each do |r|
        begin
          ret = Ayaneru.niconico.reserve(r.contentId)
        rescue => exception
          puts exception.message
          begin
            Ayaneru.twitter.create_direct_message(Ayaneru.twitter.user.screen_name, "これ以上タイムシフト予約できません．『#{r.title}』（#{r.url}）")
          rescue => exception
            puts exception.message
          end
        end
        begin
          p 'go reserve dm' if ret
          Ayaneru.twitter.create_direct_message(Ayaneru.twitter.user.screen_name, "『#{r.title}』（#{r.url}）をタイムシフト予約しました．") if ret
        rescue => exception
          puts exception.message
        end
      end
    end
  end.run
end
