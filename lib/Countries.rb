# frozen_string_literal: true

require 'json'

class Countries
  attr_accessor :countries

  def initialize
    @root = File.expand_path('..', __FILE__)
    jsondata_temp = File.read(@root + '/countries.json')
    @countries = JSON.parse(jsondata_temp)
  end

  def search_country(name)
    @countries.each do |country|
      return country if country['name']['common'] == name
    end
    nil
  end

  def make_shortlist(key1, key2)
    short_list = []
    @countries.each do |index|
      short_list << { key1 => index[key1]['common'], key2 => index[key2] }
    end
    short_list
  end

  def region_count(region_name)
    region_number = 0
    @countries.each do |index|
      region_number += 1 if index['region'] == region_name
    end
    region_number
  end
end
