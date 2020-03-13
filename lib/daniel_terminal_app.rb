# frozen_string_literal: true

require_relative 'daniel_terminal_app/version'
require_relative 'View'
require_relative 'Countries'
require_relative 'User'
require 'json'
require 'tty-prompt'

class Controller
  def initialize
    @users = [User.new('Daniel', 'password', [])]
    @view = View.new
    @countries = Countries.new
  end

  def start
    system 'clear'
    loop do
      select = @view.display_start_menu
      loggedin = false
      system 'clear'
      case select
      when 'Login'
        username = @view.displaylogin
        if File.exist?("#{username}.json")
          current_user = User.from_json("#{username}.json")
          password = @view.displaypw
          if password == current_user.password
            loggedin = true
          else
            puts 'Invalid password'
          end
        else
          puts 'No user with that name'
        end
      when 'Sign up'
        current_user = sign_up
        loggedin = true
      when 'Search for a country'
        search_for_country
      when 'Close'
        exit
      end

      while loggedin
        input = @view.display_user_menu
        system 'clear'
        case input
        when 'Add a travel entry'
          country = @view.display_search
          country = country.split.map(&:capitalize) * ' '
          if @countries.search_country(country)
            date = @view.get_date_input('When did you travel there?(Enter in DD-MM-YYYY)')
            current_user.new_travel_entry(country, @countries.search_country(country)['region'], date)
          else
            puts 'No country with that name'
          end
          system 'clear'
        when 'Search for a country'
          search_for_country
        when 'View my entries'
          @view.show_entries(current_user.travel_entries)
        when 'Show me my statistics'
          new_short_list = @countries.make_shortlist('name', 'region')

          user_uni_travel = current_user.travel_entries.map { |p| { 'country' => p['country'], 'region' => p['region'] } }.uniq

          pp user_uni_travel

          unique_regions = new_short_list.map { |p| p['region'] }.uniq

          @view.show_stat(user_uni_travel.length, new_short_list.length, 'The World')
          unique_regions.each do |region|
            count = 0
            user_uni_travel.each do |index|
              count += 1 if index['region'] == region
            end
            @view.show_stat(count, @countries.region_count(region), region)
          end
        when 'Log out'
          puts 'logging out'
          loggedin = false
          jsondata = current_user.to_json
          File.write("#{current_user.login}.json", jsondata)
        else
          puts 'Invalid Entry'
        end

      end
    end
end

  def search_for_country
    search = @view.display_search
    search = search.split.map(&:capitalize) * ' '
    @view.promptCountry(@countries.search_country(search))
  end

  def sign_up
    username = @view.displaylogin
    if File.exist?("#{username}.json")
      puts 'That user already exists, please enter another username:'
      sign_up
    else
      password = @view.displaypw
      current_user = User.new(username, password, [])
      current_user
    end
  end
end

master = Controller.new
master.start
