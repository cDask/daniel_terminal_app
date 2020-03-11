# frozen_string_literal: true

require 'tty-prompt'

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

  def displayCountry
    line
    puts 'Whats the name of the Country?'
    gets.strip
  end

  def promptCountry(hash)
    line
    if hash
        puts 'Found the following Country:'
        hash.each do |key, element|
            print "#{key}: "
            if element.class == Hash
                element.each do |key, element|
                    print "#{key}: "
                    if element.class == Hash
                        element.each do |key, element|
                            puts "#{key}: #{element}"
                        end
                    else
                        print "#{element}\n"
                    end
                end
            elsif element.class == Array
                element.each do |element|
                    print "#{element}\n"
                end
            else
                print "#{element}\n"
            end
        end
    else
        puts "No country by that name"
    end
  end

  def display_search
    line
    # puts "Whats the name of the country you searching for?"
    # search = gets.strip
    search = @prompt.ask('Whats the name of the country you searching for?') do |q|
      q.required true
      q.validate /\A\w+\Z/
      q.modify   :capitalize
    end

    search
  end

  def line
    puts '-' * 30
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
    pp arr
  end

  def show_stat(num1, num2, region)
    line
    puts "You have been in #{num1} out of #{num2} countries in #{region}"
    line
  end
  end
