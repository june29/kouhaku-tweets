require 'json'
require 'open-uri'
require 'bundler'
Bundler.require(:default)

files = Dir['2015/tweets/*/*.json']

files.each do |file|
  tweet = JSON.parse(File.read(file))
  t_id  = tweet.dig('id')

  puts "Handle tweet:#{t_id}"

  # next if     t_id <= 1
  next unless tweet.dig('retweeted_status', 'id').nil?

  name  = tweet.dig('user', 'screen_name')
  media = tweet.dig('extended_entities', 'media')

  if media && media.size > 0
    media.each do |medium|
      m_id     = medium.dig('id')
      url      = medium.dig('media_url')
      ext      = url.scan(/\.([^.]+)$/)[0][0]
      filename = "2015/media/#{t_id}___#{name}___#{m_id}.#{ext}"

      puts "Download #{url} and save to #{filename}"

      begin
        File.write(filename, open(url).read)
        sleep 3
      rescue => error
        puts error
      end
    end
  end
end
