#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

#encoding=utf-8

require 'rubygems'
require 'open-uri'
require 'erb'
require 'sanitize'
require 'metar'

# get the KLAF station's report
noaain = Metar::Raw::Noaa.new('KLAF')
metp = Metar::Parser.new(noaain)

print "Temperature is "
metp.temperature.to_s.match(/^(\d+)°(C|F)$/) {|m|
	if $2 == "C"
		puts $1 + " °C (" + (($1.to_f * 9/5) + 32).to_s + " °F)"
	elsif $2 == "F"
		puts (($1.to_f - 32) * 5/9).to_s + " °C (" + $1 + " °F)"
	end
}

puts "<html>"
puts "<body>"
puts "<img src=\"" + "http://radblast-aws.wunderground.com/cgi-bin/radar/WUNIDS_map?station=IND" + "\" />"
puts "</body>"
puts "</html>"
