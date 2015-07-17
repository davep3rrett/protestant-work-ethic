#!/usr/bin/env ruby

require 'twitter'
require './bot.rb'

# Set up the bot
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

filename = ARGV[0]

bot = Bot.new(filename, client)

# Try out a couple methods
puts bot.find_tweet("#chillin").text
puts bot.random_quote
