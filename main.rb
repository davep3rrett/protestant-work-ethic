#!/usr/bin/env ruby

require 'oauth'
require 'twitter'
require './bot.rb'

consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], {:site => "https://api.twitter.com", :scheme => :header})

request_token = consumer.get_request_token(:oauth_callback => :oob)
puts "Visit this URL: #{request_token.authorize_url}"
print "Enter the PIN: "

access_token = request_token.get_access_token(:oauth_verifier => STDIN.gets.chomp)

ACCESS_TOKEN = access_token.token
ACCESS_SECRET = access_token.secret

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_SECRET
end

quotes_file = ARGV[0]

bot = Bot.new(quotes_file, client)

while(true)
  bot.reload_quotes(quotes_file)
  tweet = bot.find_tweet("#chillin")
  response = bot.build_response(bot.get_username(tweet), bot.random_quote)
  client.update(response, {:in_reply_to_status => tweet})
  sleep(30 * 60)
end
