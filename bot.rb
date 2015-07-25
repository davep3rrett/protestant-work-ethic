#!/usr/bin/env ruby

class Bot
  def initialize(file, client)
    @quotes = Array.new
    File.open(file, 'r').each do |line|
      @quotes.push(line)
    end
    @client = client		
  end

  # Return a random element from the quotes array
  def random_quote
    return @quotes.sample
  end
	
  # Store recent tweets matching search string
  # in an array, and return a random element of
  # the array
  def find_tweet(search_string)
    tweets = Array.new
    @client.search(search_string, result_type: "recent").take(10).each do |tweet|
      tweets.push(tweet)
    end
    return tweets.sample
  end

  # Return twitter username associated with the tweet
  def get_username(tweet)
    return tweet.attrs[:user][:screen_name]
  end

  def build_response(username, quote)
    tweet = "@#{username} #{quote}"
    if tweet.length > 140
      return tweet[0,140]
    else
      return tweet
    end
  end

  def reload_quotes(file)
    puts "clearing and reloading quotes..."
    @quotes.clear
    File.open(file, 'r').each do |line|
      @quotes.push(line)
    end
    puts "quotes successfully reloaded."
  end

end
