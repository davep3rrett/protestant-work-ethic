#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'twitter'
require './bot.rb'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

quotes_file = ARGV[0]

bot = Bot.new(quotes_file, client)

while true 
  bot.reload_quotes(quotes_file)
  tweet = bot.find_tweet("#chillin")
  response = bot.build_response(bot.get_username(tweet), bot.random_quote)
  bot.respond(response, tweet)
  sleep(30 * 60)
end
