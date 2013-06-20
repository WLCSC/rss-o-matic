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

@station_code = "KLAF"

def to_fahrenheit (celsius)
	celsius = celsius.to_f
	
	return ((celsius * 9/5) + 32)
end

# get the KLAF station's report
noaain = Metar::Raw::Noaa.new(@station_code)
metp = Metar::Parser.new(noaain)

puts noaain.to_s

metp.temperature.to_s.match(/^(\d+)°(C|F)$/) {|m|
	if $2 == "C"
		celsius = $1.to_f
		fahrenheit = (($1.to_f * 9/5) + 32)
		kelvin = (celsius + -KELVIN_TO_CELSIUS)
		@temperature_string = (celsius.to_s + " °C (" + fahrenheit.to_s + " °F) (" + kelvin.to_s + " °K)").gsub("°", "&deg;")
	elsif $2 == "F"
		celsius = (($1.to_f - 32) * 5/9)
		fahrenheit = $1.to_f
		kelvin = (celsius + -KELVIN_TO_CELSIUS) 
		@temperature_string = (celsius.to_s + " °C (" + fahrenheit.to_s + " °F) (" + kelvin.to_s + " °K)").gsub("°", "&deg;")
	else
		puts "Temperature FAIL"
	end
}

@scstring = ""

if metp.sky_conditions.first != "clear skies"
	metp.sky_conditions.each do |sc|
		@scstring += sc.to_summary + "; "
	end
else
	@scsctring += metp.sky_conditions
end

puts "SC " + @scstring

if (metp.wind.direction.value == 0 && !metp.variable_wind) && metp.wind.speed.to_kilometers_per_hour == 0 && !metp.wind.gusts
	puts "Winds are reporting calm"
else
	puts "Winds from " + metp.wind.direction.to_s + " at " + metp.wind.speed.to_kilometers_per_hour.floor.to_s + " km/h (" + metp.wind.speed.to_miles_per_hour.floor.to_s + " mph)" + (metp.wind.gusts ? " gusting to " + metp.wind.gusts.to_kilometers_per_hour.floor.to_s + " km/h (" + metp.wind.gusts.to_miles_per_hour.floor.to_s + " mph)" : "")
end

puts "Wind direction: " + metp.wind.direction.to_s(:abbreviated => true)

puts metp.wind.direction.to_s(:abbreviated => true)
@wind_text = metp.wind.direction.to_s(:abbreviated => true).gsub("°","&deg;") + " (from " + metp.wind.direction.to_compass + ")" 
@wind_direction = metp.wind.direction.to_s(:abbreviated => true).gsub("°","deg")

puts "Altimeter " + metp.sea_level_pressure.to_inches_of_mercury.to_s

# FORECAST
raw_data = open("http://api.openweathermap.org/data/2.5/forecast/daily?q=West,Lafayette&mode=json").read
forecast_json_data = JSON.parse(raw_data)

@forecast = []
forecast_json_data["list"].each do |day|
	d = {}
	d[:dayname] = DateTime.strptime(day["dt"].to_s,'%s').dayname

	day_weather_items = []
	day["weather"].each do |weather_item|
		day_weather_items << weather_item["main"]
	end
	d[:weather_items] = day_weather_items

	d[:high] = to_fahrenheit(day["temp"]["max"] + KELVIN_TO_CELSIUS).floor.to_s
	d[:low] = to_fahrenheit(day["temp"]["min"] + KELVIN_TO_CELSIUS).floor.to_s
	@forecast << d
end

# start writing the HTML file

begin
	@template = ''
	puts "Reading template"
	File.open('./metar-o-matic.html.erb', 'r') do |f|
		@template = f.read
	end

	puts "Making the template now"
	template = ERB.new @template

	puts "Writing the file"
	File.open('./public/metar-o-matic.html', 'w') do |f|
		f << template.result(binding)
	end
rescue => variable
	File.open('./error.log','a') do |f|
		f << $!
		puts "An error occured: \"" + $!.to_s + "\"!"
		print variable.backtrace.join("\n")
		puts
	end
end
