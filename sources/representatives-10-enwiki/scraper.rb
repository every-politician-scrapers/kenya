#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Elected'
  end

  def table_number
    'position()>0'
  end

  class Officeholder < Scraped::HTML
    PARTY = {
      'ODM'            => 'Q1640905',
      'ODM K'          => 'Q5251223',
      'PNU'            => 'Q2559675',
      'CCU'            => 'Q5069325',
      'NARC'           => 'Q3130920',
      'KANU'           => 'Q1422517',
      'Safina'         => 'Q7398791',
      'SISI KWA SISI'  => 'Q7530800',
      'DP'             => 'Q3272441',
      'FORD K'         => 'Q5473121',
      'PDP'            => 'Q22666200',
      'SAFINA'         => 'Q7398791',

      # 'FORD A'         => 'XXX',
      # 'FORD P'         => 'XXX',
      # 'KADDU'          => 'XXX',
      # 'KADU ASILI'     => 'XXX',
      # 'KENDA'          => 'XXX',
      # 'Mazingira'      => 'XXX',
      # 'NARC KENYA'     => 'XXX',
      # 'NEW FORD KENYA' => 'XXX',
      # 'NLP'            => 'XXX',
      # 'PICK'           => 'XXX',
      # 'PPK'            => 'XXX',
      # 'UDM'            => 'XXX',
    }.freeze

    field :item do
      tds[-1].css('a/@wikidata').text
    end

    field :name do
      (tds[-1].css('a').any? ? tds[-1].css('a').text : tds[-1].text).gsub(/\(.*?\)/, '').tidy
    end

    field :constituency do
      return if tds.count == 2

      tds[-3].css('a/@wikidata').text
    end

    field :constituencyLabel do
      return if tds.count == 2

      tds[-3].text.tidy
    end

    field :party do
      PARTY[partyLabel]
    end

    field :partyLabel do
      tds[-2].text.gsub(/\(.*?\)/, '').tidy
    end

    def empty?
      name.include? 'Vacant'
    end

    def tds
      noko.css('td')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
