#!/user/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'oauth'
require 'twitter'

def get_oauth_consumer(consumer_key, consumer_secret)
  consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "https://api.twitter.com", :scheme => :header})
  return consumer
end

def get_access_token(consumer)
  request_token = consumer.get_request_token(:oauth_callback => :oob)
  puts "Visit this URL: #{request_token.authorize_url}"
  print "Enter the PIN: "
  return request_token.get_access_token(:oauth_verifier => STDIN.gets.chomp)
end

consumer = get_oauth_consumer(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])

access_token = get_access_token(consumer)

File.open("access_token", "w") do |file|
  file.puts "export ACCESS_TOKEN=#{access_token.token}"
  file.puts "export ACCESS_SECRET=#{access_token.secret}"
end
