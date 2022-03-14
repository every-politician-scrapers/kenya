#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  # TODO: make this easier to override
  def holder_entries
    noko.css('td.navbox-list ul li')
  end

  class Officeholder < OfficeholderBase
    def raw_combo_date
      noko.text.scan(/\((.*?)\)/).flatten.last
    end

    def raw_combo_dates
      ds = super
      ds.last.prepend(ds.first[0...2]) if ds.last.length == 2
      ds
    end

    def combo_date?
      true
    end

    def item
      name_cell.attr('wikidata')
    end

    def name
      nake_cell.text.tidy
    end

    def name_cell
      noko.css('a').first
    end

    def empty?
      false
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
