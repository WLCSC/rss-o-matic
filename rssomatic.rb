#!/home/sam/.rvm/rubies/ruby-2.0.0-p195/bin/ruby

require 'rubygems'
require 'open-uri'
require 'erb'
require 'sanitize'
require 'nokogiri'

begin
rss = Nokogiri::XML(open(ARGV[0]))
@details = ARGV[2].match /y/
@count = ARGV[3].to_i || 0

@offset = ARGV[4].to_i || 0

@title = rss.search("channel > title")[0].content
@items = []
rss.search("item").each do |i|
	@items << {:title => i.search("title")[0].content, :description => i.search('description')[0].content}
end
if @count != 0
	@items = @items[@offset...(@offset + (@count))]
end
# ...etc

@template = ''
File.open('template.html.erb','r') do |f|
	@template = f.read
end
File.open './error.log', 'a' do |f|
		f << "OK #{ARGV[1]}"
	end

template = ERB.new @template
File.open( ARGV[1], 'w') do |f|
	f << template.result(binding)
end
rescue
	File.open './error.log', 'a' do |f|
		f << $!
	end
end
