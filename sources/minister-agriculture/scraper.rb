#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.css('td.navbox-list ul li')
  end

  class Officeholder < OfficeholderNonTableBase
    def name_node
      noko.css('a').last
    end

    def raw_combo_date
      years = noko.text[/\((.*?)\)/, 1]
      years =~ /^\d{4}$/ ? "#{years} - #{years}" : years
    end

    def raw_combo_dates
      ds = super
      ds.last.prepend(ds.first[0...2]) if ds.last.length == 2
      ds
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
