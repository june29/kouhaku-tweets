require 'logger'
require 'bundler'
Bundler.require(:default)
Dotenv.load

LOGGER = Logger.new(STDOUT)
LOGGER.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
STDOUT.sync = true

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
end

client.filter(track: "NHK紅白") do |object|
  begin
    next unless object.is_a?(Twitter::Tweet)

    tweet = object
    LOGGER.info tweet.to_h
  rescue => error
    LOGGER.info error
  end
end
