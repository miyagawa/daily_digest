$:.push File.expand_path("../lib", __FILE__)
require 'dotenv'
require 'daily_digest'
require 'tempfile'
require 'pathname'
require 'fileutils'

Dotenv.load

task :deliver do
  puts "---> Getting unread items from Pocket"
  pocket = DailyDigest::Pocket.new(ENV['POCKET_ACCESS_TOKEN'], ENV['POCKET_CONSUMER_KEY'], ENV['POCKET_FAVORITES'])
  items = pocket.list

  puts "---> Parsing items with Readability"
  reader = DailyDigest::Reader.new(ENV['READABILITY_PARSER_KEY'])
  articles = items.map { |item|
    puts "Parsing #{item.title}"
    reader.get(item.url)
  }.select(&:valid?)

  basename = "dailydigest-#{Time.now.strftime('%Y%m%d%H%M%S')}"
  tempfile = basename + ".html"

  puts "---> Rendering pages in HTML"
  kindlegen = DailyDigest::Kindlegen.new
  kindlegen.render(articles, tempfile)

  puts "---> Converting rendered pages to Mobi with Kindlegen"
  kindlegen.convert(tempfile, basename + ".mobi")

  File.delete(tempfile)

  mobi = basename + ".mobi"
  puts "Generated #{mobi} (#{File.size(mobi)} bytes)"

  if ENV['KINDLE_MAILTO']
    puts "---> Sending #{mobi} to Kindle Personal Document"
    delivery = DailyDigest::Delivery.new
    delivery.deliver(mobi)
  end

  outbox = "#{ENV['HOME']}/Dropbox/Public/Kindle"
  if File.exists?(outbox)
    puts "---> Publishing #{mobi} to your Dropbox"
    FileUtils.move(mobi, outbox)
  end
end

