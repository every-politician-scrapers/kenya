#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath('.//h2[contains(.,"Institutions")]/following::*').remove
    noko.xpath('.//h2[contains(.,"Ministers")]/following::ol//li[a]')
  end

  class Officeholder < OfficeholderNonTableBase
    def name_node
      noko.css('a').last
    end

    # TODO: only take consecutive years
    def combo_date
      noko.text.scan(/(\d{4})/).flatten.values_at(0, -1)
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
