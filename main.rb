#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'logger'
require 'oauth'
require 'twitter'
require './bot.rb'
require './twitter_authenticate.rb'

log = Logger.new('log.txt')

client = TwitterAuthenticate.oauth_dance(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])

quotes_file = ARGV[0]

bot = Bot.new(quotes_file, client)

while true 
  bot.reload_quotes(quotes_file)
  tweet = bot.find_tweet("#chillin")
  response = bot.build_response(bot.get_username(tweet), bot.random_quote)
  bot.respond(response, tweet)
  sleep(30 * 60)
end
