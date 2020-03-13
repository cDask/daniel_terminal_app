# frozen_string_literal: true

require 'tty-prompt'
require 'tty-table'
require 'tty-font'
require 'pastel'

class View
  attr_reader :input

  def initialize
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
  end

  def display_start_menu
    font = TTY::Font.new(:doom)
    puts font.write('Traveler')
    line
    @input = @prompt.select('What would you like to do?', ['Login', 'Sign up', 'Search for a country', 'Close'])
    @input
  end

  def display_user_menu
    line
    @input = @prompt.select('What would you like to do?', ['Add a travel entry', 'Search for a country', 'View my entries', 'Show me my statistics', 'Log out'])
    @input
  end

  def promptCountry(hash)
    line
    if hash
      font = TTY::Font.new(:doom)
      puts font.write(hash['name']['common'])
      line
      puts @pastel.bold("Officially known as: #{hash['name']['official']}")
      line
      puts @pastel.bold("Name in countrys\' native language:")
      lang_code = hash['name']['native'].keys[0]
      print @pastel.bold('Official name: ')
      puts (hash['name']['native'][lang_code]['official']).to_s
      print @pastel.bold('Common name: ')
      puts (hash['name']['native'][lang_code]['official']).to_s

      line

      puts @pastel.bold.underline.on_yellow('General Information')
      general_table = TTY::Table.new header: [@pastel.bold('Language'), @pastel.bold('Web Suffix'), @pastel.bold('International Dialing'), @pastel.bold('Independence')], rows: [[hash['languages'][lang_code], hash['tld'][0], hash['idd'].values[0] + hash['idd'].values[1][0].to_s, hash['independent'].to_s]]
      puts general_table.render(:unicode)

      line

      puts @pastel.bold.underline.on_green('Currency')
      currency_holder = hash['currencies']
      currency_code = hash['currencies'].keys[0]
      currency_table = TTY::Table.new header: [@pastel.bold('Name'), @pastel.bold('Symbol'), @pastel.bold('Code')], rows: [[currency_holder[currency_code]['name'], currency_holder[currency_code]['symbol'], currency_code]]
      puts currency_table.render(:unicode)

      line

      puts @pastel.bold.underline.on_blue('Geography')
      geography_table = TTY::Table.new header: [@pastel.bold('Capital'), @pastel.bold('Region'), @pastel.bold('Sub-region'), @pastel.bold('Landlocked')], rows: [[hash['capital'][0], hash['region'], hash['subregion'], hash['landlocked']]]
      puts geography_table.render(:unicode)

      line

      puts @pastel.bold.underline.on_red('Name of Country in Different Languages')
      col = []
      hash['translations'].each do |v|
        row = []
        row << v[0]
        row << v[1]['official']
        row << v[1]['common']
        col << row
      end
      translation_table = TTY::Table.new([@pastel.bold('Language'), @pastel.bold('Official name'), @pastel.bold('Common name')], col)
      puts translation_table.render(:unicode)

      line

    else
      puts 'No country by that name'
    end
  end

  def display_search
    line
    search = @prompt.ask('Whats the name of the country?') do |q|
      q.required true
      q.modify  :strip
      q.modify  :capitalize
    end
    search
  end

  def line
    puts '-' * 50
  end

  def displaylogin
    line
    username = @prompt.ask('Username:', default: ENV['USER'])
    username
  end

  def displaypw
    line
    password = @prompt.mask('password:')
    password
  end

  def get_input(message)
    line
    puts message
    input = gets.strip
    input
  end

  def show_entries(arr)
    line
    col = []
    arr.each do |v|
      row = []
      row << v['date']
      row << v['country']
      row << v['region']
      col << row
    end
    entry_table = TTY::Table.new(%w[Date Country Region], col)
    puts entry_table.render(:unicode)
  end

  def show_stat(num1, num2, region)
    line
    puts "You have been in #{num1} out of #{num2} countries in #{region}"
  end

  def get_date_input(message)
    validator = lambda { |str|
      begin
        Date.parse(str)
        return str
      rescue ArgumentError
        return nil
      end
    }
    @prompt.ask(message, convert: :date) do |q|
      q.validate(validator, 'Invalid Date - Please enter in DD-MM-YYYY form')
    end
  end
end
