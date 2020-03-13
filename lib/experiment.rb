# frozen_string_literal: true

require 'json'

jsondata_temp = File.read('countries.json')
countries = JSON.parse(jsondata_temp)

# pp countries[1]["flag"]
jsondata = countries.to_json
File.write('countries.json', jsondata)
hash = {}
puts hash.class.class

# do
