#!/usr/local/bin/ruby

# -*- encoding: utf-8 -*-

#encoding=utf-8

require 'rubygems'
require 'open-uri'
require 'erb'
require 'sanitize'
require 'json'

def log(tag,message)
	puts tag + ": " + message
end

rss_feeds = [
             "http://rss.slashdot.org/Slashdot/slashdot",
             "http://www.jconline.com/apps/pbcs.dll/section?category=news%25&template=rss",
             "http://www.jconline.com/apps/pbcs.dll/section?category=sports%25&template=rss",
             "http://news.google.com/news?pz=1&jfkl=true&cf=all&ned=us&hl=en&topic=w&output=rss",
             "http://news.google.com/news?pz=1&jfkl=true&cf=all&ned=us&hl=en&topic=n&output=rss",
             "http://news.google.com/news?q=West+Lafayette,+Indiana&hl=en&safe=active&client=firefox-a&hs=ozw&rls=org.mozilla:en-US:official&bav=on.2,or.r_gc.r_pw.&biw=1280&bih=761&um=1&ie=UTF-8&output=rss",
             "http://feeds.reuters.com/news/artsculture",
             "http://feeds.reuters.com/reuters/businessNews",
             "http://feeds.reuters.com/ReutersBusinessTravel",
             "http://feeds.reuters.com/reuters/companyNews",
             "http://feeds.reuters.com/Counterparties",
             "http://feeds.reuters.com/reuters/Election2012",
             "http://feeds.reuters.com/reuters/entertainment",
             "http://feeds.reuters.com/reuters/environment",
             "http://feeds.reuters.com/reuters/healthNews",
             "http://feeds.reuters.com/reuters/lifestyle",
             "http://feeds.reuters.com/news/reutersmedia",
             "http://feeds.reuters.com/news/wealth",
             "http://feeds.reuters.com/reuters/MostRead",
             "http://feeds.reuters.com/reuters/oddlyEnoughNews",
             "http://feeds.reuters.com/ReutersPictures",
             "http://feeds.reuters.com/reuters/peopleNews",
             "http://feeds.reuters.com/Reuters/PoliticsNews",
             "http://feeds.reuters.com/reuters/scienceNews",
             "http://feeds.reuters.com/reuters/sportsNews",
             "http://feeds.reuters.com/reuters/technologyNews",
             "http://feeds.reuters.com/reuters/topNews",
             "http://feeds.reuters.com/Reuters/domesticNews",
             "http://feeds.reuters.com/Reuters/worldNews"
            ];

html_counter = 0

rss_feeds.each do |rss_feed|

	# set teh variablez

	@rss_feed_title = "[RSS FEED TITLE]"

	rss = Nokogiri::XML(open(rss_feed))
	@rss_feed_title = rss.search("channel > title")[0].content
	
	@rss_items = []
	
	rss.search("item").each do |item|
		item_title = item.search("title")[0].content
		item_description = item.search("description")[0].content.gsub(/<.*>/m, "")

		test_string = (item_title + item_description).downcase

		# naughty word filtering
		if(test_string.include? "porn")
		else
			@rss_items << {:title => item_title, :description => item_description}
		end
	end

	if !(@rss_items.empty?)
		html_counter += 1

		begin
			@template = ""
			log("WRITE", "Reading the template")
			File.open('./rss-o-matic.html.erb', 'r') do |f|
				@template = f.read
			end
			
			log("WRITE", "ERB-ifying the template")
			template = ERB.new @template
			
			log("WRITE", "Writing the file")
			File.open("./public-rss-o-matic/index-" + html_counter.to_s + ".html", 'w') do |f|
				f << template.result(binding)
			end
		rescue => variable
			File.open('./error.log', 'a') do |f|
				f << $!
				log("WRITE", "ERROR: \"" + $!.to_s + "\"!")
				print variable.backtrace.join("\n")
				log("WRITE", "END ERROR")
			end
		end
	end
end
