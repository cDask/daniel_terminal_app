# frozen_string_literal: true

require 'tty-prompt'
require 'tty-table'
require 'tty-font'

class View
  attr_reader :input

  def initialize
    @prompt = TTY::Prompt.new
  end

  def display_start_menu
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
      puts "Officially known as: #{hash["name"]["official"]}"
      line
      puts "Name in countries native language:"
      lang_code = hash["name"]["native"].keys[0]
      puts "Official name: #{hash["name"]["native"][lang_code]["official"]}"
      puts "Common name: #{hash["name"]["native"][lang_code]["official"]}"
      line
      col =[]
      hash["translations"].each do |v|
        row = []
        row << v[0]
        row << v[1]["official"]
        row << v[1]["common"]
        col << row
      end
      translation_table = TTY::Table.new(['Language','Official name','Common name'], col)
      puts translation_table.render(:unicode)

      table = TTY::Table.new ['header1', 'header2'], [['a1', 'a2'], ['b1', 'b2']]
      puts table.render do |renderer|
        renderer.border.separator = :each_row
      end
      # renderer = TTY::Table::Renderer::Unicode.new(translation_table)
      # test = renderer.render do |renderer|
      #   renderer.border.separator = :each_row
      # end
      # puts test
      pp hash

        # puts 'Found the following Country:'
        # hash.each do |key, element|
        #     print "#{key}: "
        #     if element.class == Hash
        #         element.each do |key, element|
        #             print "#{key}: "
        #             if element.class == Hash
        #                 element.each do |key, element|
        #                     puts "#{key}: #{element}"
        #                 end
        #             else
        #                 print "#{element}\n"
        #             end
        #         end
        #     elsif element.class == Array
        #         element.each do |element|
        #             print "#{element}\n"
        #         end
        #     else
        #         print "#{element}\n"
        #     end
        # end
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
      q.validate /\A\w+\Z/
      q.modify   :capitalize
    end

    search
  end

  def line
    puts '-' * 40
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
    @prompt.ask(message, convert: :date) do |q|
      # /^(((0?[1-9]|1[012])/(0?[1-9]|1\d|2[0-8])|(0?[13456789]|1[012])/(29|30)|(0?[13578]|1[02])/31)/(19|[2-9]\d)\d{2}|0?2/29/((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$/
      q.validate(/\d{2}\-\d{2}\-\d{2}/, 'Invalid Date - Please enter in DD-MM-YY format')

    end
  end
end
