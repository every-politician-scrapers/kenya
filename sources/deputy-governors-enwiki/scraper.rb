#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MinistersList < Scraped::HTML
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  field :deputies do
    member_entries.map { |ul| fragment(ul => Officeholder).to_h }
  end

  private

  def member_entries
    table.flat_map { |table| table.xpath('.//tr[td]') }
  end

  def table
    noko.xpath('//table[.//th[contains(.,"Governor")]]')
  end
end

class Officeholder < Scraped::HTML
  field :county do
    tds[1].css('a/@wikidata').text
  end

  field :countyLabel do
    tds[1].css('a').text
  end

  field :deputy do
    tds[3].css('a/@wikidata').text
  end

  field :deputyLabel do
    tds[3].text.gsub('TBD', '').tidy
  end

  field :start do
    '2017-08-08'
  end

  private

  def tds
    noko.css('td')
  end
end

url = 'https://en.wikipedia.org/wiki/Counties_of_Kenya'
data = MinistersList.new(response: Scraped::Request.new(url: url).response).deputies

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
