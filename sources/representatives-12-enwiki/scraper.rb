#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Member'
  end

  def table_number
    'position()>1'
  end

  class Officeholder < Scraped::HTML
    PARTY = {
      'Amani National Congress' => 'Q47489380',
      'CHAMA CHA UZALENDO' => 'Q5069325',
      'Chama Cha Mashinani' => 'Q60776120',
      'DEMOCRATIC PARTY OF KENYA' => 'Q3272441',
      'Economic Freedom Party' => 'Q42954840',
      'FORD - Kenya' => 'Q5473121',
      'Forum for Restoration of Democracy - Kenya' => 'Q5473121',
      'Frontier Alliance Party' => 'Q47492871',
      'Independent' => 'Q327591',
      'Jubilee Party' => 'Q27963537',
      'KENYA PATRIOTS PARTY' => 'Q47492848',
      'Kenya African National Union' => 'Q1422517',
      'Kenya National Congress' => 'Q6392670',
      'Maendeleo Chap Chap Party' => 'Q47489396',
      'Movement for Democracy and Growth' => 'Q111179653',
      'Muungano Party' => 'Q22666185',
      'National Agenda Party of Kenya' => 'Q47492879',
      'New Democrats' => 'Q47490108',
      'Orange Democratic Movement' => 'Q1640905',
      'PARTY FOR DEVELOPMENT AND REFORM' => 'Q7141057',
      'Party of Development and Reforms' => 'Q7141057',
      'Party of National Unity' => 'Q2559675',
      'Peoples Democratic Party' => 'Q22666200',
      'Wiper Democratic Movement - Kenya' => 'Q5251223',
    }

    field :item do
      tds[-2].css('a/@wikidata').text
    end

    field :itemLabel do
      tds[-2].text.tidy
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
      tds[-1].text.gsub(/\(.*?\)/, '').tidy
    end

    def empty?
      false
    end

    def tds
      noko.css('td')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
