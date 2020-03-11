# frozen_string_literal: true

require_relative 'Countries'
require 'json'

class User
  attr_reader :login, :password, :travel_entries

  def initialize(login, pw, travel_entries)
    @login = login
    @password = pw
    @travel_entries = travel_entries
  end

  def new_travel_entry(country_name, region, date)
    @travel_entries << { "country" => country_name, "region" => region, "date" => date }
  end

  def to_json(*_args)
    { 'login' => @login, 'password' => @password, 'travel_entries' => @travel_entries }.to_json
  end

  def self.from_json(string)
    data = JSON.load(File.read(string))
    # pp data
    new(data['login'], data['password'], data['travel_entries'])
  end
end
