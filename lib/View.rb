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
    puts font.write("Traveler")
    line
    @input = @prompt.select('What would you like to do?', ['Login', 'Sign up', 'Search for a country', 'Close'])
    # pp @input
    @input
  end

  def display_user_menu
    line
    # puts "What would you like to do?"
    # puts "1. Add a travel entry"
    # puts "2. Search for a country"
    # puts "3. View my entries"
    # puts "4. Show me my statistics"
    # puts "5. Log out"
    # @input = gets.strip.to_i
    @input = @prompt.select('What would you like to do?', ['Add a travel entry', 'Search for a country', 'View my entries', 'Show me my statistics', 'Log out'])
    # pp @input
    @input
  end

  # def displayCountry
  #   line
  #   puts 'Whats the name of the Country?'
  #   gets.strip
  # end

  def promptCountry(hash)
    line
    if hash
      font = TTY::Font.new(:doom)
      puts font.write(hash["name"]["common"])
      line()
      # puts hash["name"]["common"]
      puts @pastel.bold("Officially known as: #{hash["name"]["official"]}")
      line
      puts @pastel.bold("Name in countrys\' native language:")
      lang_code = hash["name"]["native"].keys[0]
      print @pastel.bold("Official name: ")
      puts "#{hash["name"]["native"][lang_code]["official"]}"
      print @pastel.bold("Common name: ")
      puts "#{hash["name"]["native"][lang_code]["official"]}"

      line

      puts @pastel.bold.underline.on_black("General Information")
      general_table = TTY::Table.new header: [@pastel.bold('Language'),@pastel.bold('Web Suffix'),@pastel.bold('International Dialing'),@pastel.bold('Independence')], rows: [[hash["languages"][lang_code],hash["tld"][0],hash["idd"].values[0] + hash["idd"].values[1][0].to_s,hash["independent"].to_s]]
      puts general_table.render(:unicode)

      line

      puts @pastel.bold.underline.on_green("Currency")
      currency_holder = hash["currencies"]
      currency_code = hash["currencies"].keys[0]
      currency_table = TTY::Table.new header: [@pastel.bold('Name'),@pastel.bold('Symbol'),@pastel.bold('Code')], rows: [[currency_holder[currency_code]["name"],currency_holder[currency_code]["symbol"],currency_code]]
      puts currency_table.render(:unicode)
      
      line

      puts @pastel.bold.underline.on_blue("Geography")
      geography_table = TTY::Table.new header: [@pastel.bold('Capital'),@pastel.bold('Region'),@pastel.bold('Sub-region'),@pastel.bold('Landlocked')], rows: [[hash["capital"][0],hash["region"],hash["subregion"],hash["landlocked"]]]
      # general_table = TTY::Table.new(,)
      puts geography_table.render(:unicode)

      line

      puts @pastel.bold.underline.on_red("Name of Country in Different Languages")
      col =[]
      hash["translations"].each do |v|
        row = []
        row << v[0]
        row << v[1]["official"]
        row << v[1]["common"]
        col << row
      end
      translation_table = TTY::Table.new([@pastel.bold('Language'),@pastel.bold('Official name'),@pastel.bold('Common name')], col)
      puts translation_table.render(:unicode)
      
      line

      # Attempt to make fully segregated table
      # table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']]
      # puts table.render do |renderer|
      #   renderer.border.separator = :each_row
      # end

      # pp hash
    else
        puts "No country by that name"
    end
  end

  def display_search
    line
    # puts "Whats the name of the country you searching for?"
    # search = gets.strip
    search = @prompt.ask('Whats the name of the country?') do |q|
      q.required true
      # q.validate /\A\w+\Z/
      q.modify  :strip
      q.modify  :capitalize
      # q.modify  :titleize
    end
    puts search
    search
  end

  def line
    puts '-' * 50
  end

  def displaylogin
    line
    # puts "Please enter username:"
    # username = gets.strip
    username = @prompt.ask('Username:', default: ENV['USER'])
    # pp username
    # line()
    username
  end

  def displaypw
    line
    password = @prompt.mask('password:')
    # pp password
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
      col =[]
      arr.each do |v|
        row = []
        row << v["date"]
        row << v["country"]
        row << v["region"]
        col << row
      end
    entry_table = TTY::Table.new(['Date','Country','Region'], col)
    puts entry_table.render(:unicode)
  end

  def show_stat(num1, num2, region)
    line
    puts "You have been in #{num1} out of #{num2} countries in #{region}"
  end
  
  def get_date_input(message)
    validator = -> (str) {
      begin
        Date.parse(str)
        return str
      rescue ArgumentError
        return nil
      end
    }
    @prompt.ask(message, convert: :date) do |q|
      q.validate(validator,"Invalid Date - Please enter in DD-MM-YYYY form")
    end
  end
end
