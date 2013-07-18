rss-o-matic
===========

RSS-o-Matic downloads all of the RSS feeds (The URLs are specified in `rss-o-matic.rb` as an array called `rss_feeds`) given and spits out a bunch of HTML files into `public-rss-o-matic`.

Those HTML files should then be put up for display on the Commons display(s) (or other displays that are 1024px by 768px).

metar-o-matic
=============

METAR-o-Matic downloads a METAR report for the specified station code (specified in `metar-o-matic.rb` on line 27 as `@station_code`) and a forecast from [OpenWeatherMap](http://openweathermap.org), then spits out an HTML file into `public-metar-o-matic`.

That HTML file should then be put up for display on the Commons display(s) (or other displays that are 1024px by 768px).

twitter-o-matic
===============

Twitter-o-Matic downloads the latest tweets using Twitter's `twitter` gem, and spits out an HTML file into `public-twitter-o-matic`

However, for it to work, the Twitter configuration must be done in `secret_stuff.rb`.

Example of `secret_stuff.rb`:
<pre>
Twitter.configure do |config|
	config.consumer_key = "[consumer key]"
	config.consumer_secret = "[consumer secret]"
	config.oauth_token = "[oauth token]"
	config.oauth_token_secret = "[oauth token secret]"
end
</pre>

The HTML file produced should then be put up for display on the Commons display(s) (or other displays that are 1024px by 768px).

License
=======

Copyright 2013 Kristofer Rye (based on another version [Copyrighted 2013, by Brad Thompson, no longer distributed]), distributed under the terms of the GNU General Public License

RSS-o-Matic is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

RSS-o-Matic is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with RSS-o-Matic. If not, see http://www.gnu.org/licenses/.
