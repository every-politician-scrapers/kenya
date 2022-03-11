#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Name'
  end

  def table_number
    'position()>0'
  end

  class Officeholder < Scraped::HTML
    field :item do
      tds[-2].css('a/@wikidata').text
    end

    field :itemLabel do
      (tds[-2].css('a').any? ? tds[-2].css('a').text : tds[-2].text).gsub(/\(.*?\)/, '').tidy
    end

    field :party do
      tds[-1].css('a/@wikidata').text
    end

    field :partyLabel do
      tds[-1].text.tidy
    end

    def empty?
      itemLabel.include? 'Vacant'
    end

    def tds
      noko.css('td')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
