#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath('.//h2[contains(.,"List of ministers")]/following::ul[position() < 3]//li[a]')
  end

  class Officeholder < OfficeholderNonTableBase
    def name_node
      noko.css('a').first
    end

    def raw_combo_date
      noko.text.scan(/\((.*?)\)/).flatten.last
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
