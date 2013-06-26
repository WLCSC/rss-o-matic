#!/bin/bash

rssomatic.rb "http://rss.slashdot.org/Slashdot/slashdot" slashdot.html no 6
rssomatic.rb "http://www.jconline.com/apps/pbcs.dll/section?category=news%25&template=rss" JCLatest.html no 5
rssomatic.rb "http://www.jconline.com/apps/pbcs.dll/section?category=sports%25&template=rss" JCSports.html no 5
rssomatic.rb "http://news.google.com/news?pz=1&jfkl=true&cf=all&ned=us&hl=en&topic=w&output=rss" GoogleWorld.html no 4
rssomatic.rb "http://news.google.com/news?pz=1&jfkl=true&cf=all&ned=us&hl=en&topic=n&output=rss" GoogleUS.html no 4
rssomatic.rb "http://news.google.com/news?q=West+Lafayette,+Indiana&hl=en&safe=active&client=firefox-a&hs=ozw&rls=org.mozilla:en-US:official&bav=on.2,or.r_gc.r_pw.&biw=1280&bih=761&um=1&ie=UTF-8&output=rss" GoogleWestLafayette.html no 5
weatheromatic.rb 47906 weather.html
