#!/usr/local/bin/ruby

require 'rubygems'
require 'open-uri'
require 'erb'
require 'sanitize'
require 'nokogiri'

begin
rss = Nokogiri::XML(open("http://www.google.com/ig/api?weather=" + ARGV[0]))

@title = "Weather for" + rss.search("forecast_information city")[0].attributes['data'].value

@current = rss.search("current_conditions")[0]
@c_condition = @current.search("condition")[0]['data']
@c_gif_path = "http://www.google.com" + @current.search("icon")[0]['data']
@c_temp = @current.search("temp_f")[0]['data']
@c_humidity = @current.search("humidity")[0]['data'].split(':')[1].to_i
@c_w_dir = @current.search("wind_condition")[0]['data'].split(' ')[1]
@c_w_speed = @current.search("wind_condition")[0]['data'].split(' ')[3].to_i

@forecast = []

rss.search("forecast_conditions").each do |e|
	r= {}
	r[:condition] = e.search("condition")[0]['data']
	r[:gif_path] = "http://www.google.com" + e.search("icon")[0]['data']
	r[:low] = e.search("low")[0]['data']
	r[:high] = e.search("high")[0]['data']
	r[:day] = e.search("day_of_week")[0]['data']
	@forecast << r
end


@template = ''
File.open('/var/public/rss/weather_template.html.erb','r') do |f|
	@template = f.read
end
File.open './error.log', 'a' do |f|
		f << "OK #{ARGV[1]}\n"
	end

template = ERB.new @template
File.open('/var/www/' + ARGV[1], 'w') do |f|
	f << template.result(binding)
end
rescue
	File.open './error.log', 'a' do |f|
		f << $! + "\n"
	end
end