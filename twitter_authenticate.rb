#!/user/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'oauth'
require 'twitter'

module TwitterAuthenticate

  def self.get_oauth_consumer(consumer_key, consumer_secret)
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "https://api.twitter.com", :scheme => :header})
    return consumer
  end

  def self.get_access_token(consumer)
    request_token = consumer.get_request_token(:oauth_callback => :oob)
    puts "Visit this URL: #{request_token.authorize_url}"
    print "Enter the PIN: "
    return request_token.get_access_token(:oauth_verifier => STDIN.gets.chomp)
  end

  def self.get_twitter_client(consumer_key, consumer_secret, access_token, access_secret)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_secret
    end
    return client
  end

  def self.oauth_dance(consumer_key, consumer_secret)
    consumer = get_oauth_consumer(consumer_key, consumer_secret)
    access_token = get_access_token(consumer)
    client = get_twitter_client(consumer_key, consumer_secret, access_token.token, access_token.secret)
    return client
  end

end
