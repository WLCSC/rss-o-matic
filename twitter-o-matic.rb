#!/usr/local/bin/ruby

# -*- encoding: utf-8 -*-

#encoding=utf-8

require 'rubygems'
require 'open-uri'
require 'erb'
require 'sanitize'
require 'json'
require 'twitter'
require './secret_stuff'

def time_ago_in_words(from_time, include_seconds = false)
	distance_of_time_in_words(from_time, Time.now, include_seconds)
end

def log(tag,message)
	puts tag + ": " + message
end

@twitter_account = "team461wbi"

tweetz = Twitter.user_timeline(@twitter_account)

@tweets = []

tweetz.each do |twt|
	text = twt.text
	twt.urls.each do |url|
		text.gsub!(url.url, "<a href=\"" + url.expanded_url + "\">" + url.display_url + "</a>")
	end
	twt.media.each do |media|
		text.gsub!(media.url, "<a href=\"" + media.expanded_url + "\">" + media.display_url + "</a>")
	end
	twt.hashtags.each do |hashtag|
		text.gsub!("#" + hashtag.text, "<a href=\"https://twitter.com/search/?q=%23" + hashtag.text + "\" target=\"_blank\">" + "#" + hashtag.text + "</a>")
	end
	@tweets << {:text => text, :info => "by @" + twt.from_user + ", on " + twt.created_at().iso8601.split("T")[0] + " at " + twt.created_at().iso8601.split("T")[1].split("-")[0].split(":")[0..1].join(":")}
end

begin
	@template = ""
	log("WRITE", "Reading the template")
	File.open('./twitter-o-matic.html.erb', 'r') do |f|
		@template = f.read
	end
	
	log("WRITE", "ERB-ifying the template")
	template = ERB.new @template
	
	log("WRITE", "Writing the file")
	File.open("./public-twitter-o-matic/index.html", 'w') do |f|
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
