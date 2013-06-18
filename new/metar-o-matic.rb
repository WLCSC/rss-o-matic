#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

#encoding=utf-8

require 'rubygems'
require 'open-uri'
require 'erb'
require 'sanitize'
require 'json'
require 'date'
require 'metar'
require 'open-uri'

class Date
	def dayname
		DAYNAMES[self.wday]
	end

	def abbr_dayname
		ABBR_DAYNAMES[self.wday]
	end
end

KELVIN_TO_CELSIUS = -273.15

# get the KLAF station's report
noaain = Metar::Raw::Noaa.new('KLAF')
metp = Metar::Parser.new(noaain)

puts noaain.to_s

print "Temperature is "
metp.temperature.to_s.match(/^(\d+)°(C|F)$/) {|m|
	if $2 == "C"
		puts $1 + " °C (" + (($1.to_f * 9/5) + 32).to_s + " °F)"
	elsif $2 == "F"
		puts (($1.to_f - 32) * 5/9).to_s + " °C (" + $1 + " °F)"
	else
		puts " not being happy [not matching teh regex's for some reason] :("
	end
}

puts "Sky Conditions are:"
if metp.sky_conditions.first != "clear skies"
	metp.sky_conditions.each do |sc|
		puts sc.to_summary + (sc.type ? " of type " + sc.type : "") + (sc.height ? " at " + sc.height.to_s : "")
	end
else
	puts metp.sky_conditions
end

if metp.wind.direction.value == 0 && metp.wind.speed.to_kilometers_per_hour == 0 && !metp.wind.gusts
	puts "Winds are reporting calm"
else
	puts "Winds from " + metp.wind.direction.to_s + " at " + metp.wind.speed.to_kilometers_per_hour.floor.to_s + " km/h (" + metp.wind.speed.to_miles_per_hour.floor.to_s + " mph)" + (metp.wind.gusts ? " gusting to " + metp.wind.gusts.to_kilometers_per_hour.floor.to_s + " km/h (" + metp.wind.gusts.to_miles_per_hour.floor.to_s + " mph)" : "")
end

puts "Altimeter " + metp.sea_level_pressure.to_inches_of_mercury.to_s



# FORECAST
raw_data = open("http://api.openweathermap.org/data/2.5/forecast/daily?q=West,Lafayette&mode=json").read
forecast_json_data = JSON.parse(raw_data)

puts forecast_json_data

puts forecast_json_data["cod"]
puts forecast_json_data["city"]["name"]
forecast_json_data["list"].each do |day|
	print DateTime.strptime(day["dt"].to_s,'%s').dayname + ": "
	day["weather"].each do |weather_item|
		print weather_item["main"] + "; "
	end
	puts "high " + (day["temp"]["max"] + KELVIN_TO_CELSIUS).floor.to_s + "; low " + (day["temp"]["min"] + KELVIN_TO_CELSIUS).floor.to_s
end
