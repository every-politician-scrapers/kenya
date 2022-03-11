#!/bin/bash

cd $(dirname $0)

# curl https://raw.githubusercontent.com/everypolitician/everypolitician-data/master/data/Kenya/Assembly/term-11.csv| qsv select wikidata,name,wikidata_group,group,wikidata_area,area,start_date,end_date,gender | qsv rename item,itemLabel,party,partyLabel,area,areaLabel,startDate,endDate,gender > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s itemLabel,startDate | ifne tee wikidata.csv
bundle exec ruby diff.rb | qsv sort -s itemlabel,startdate | tee diff.csv

cd -