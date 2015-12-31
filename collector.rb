require 'json'
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

    id = tweet.id
    dirname = File.join(__dir__, '2015', 'tweets', ((id / 10000).to_i * 10000).to_s)

    FileUtils.mkdir(dirname) unless File.exist?(dirname)
    File.write(File.join(dirname, "#{id}.json"), tweet.to_hash.to_json)

    puts "[#{tweet.id}][#{(tweet.created_at + 60 * 60 * 9).strftime('%H:%M:%S')}] @#{tweet.user.screen_name}: #{tweet.text.gsub(/\n/, '')}"
  rescue => error
    LOGGER.info error
  end
end
