
require 'net/http'
require 'io/console'
require 'tty-prompt'
require 'json'
require_relative 'password'

system 'clear'

title = "Convert or know exchange rate\n\n"
t_up = title.upcase
puts t_up

puts "Put your API KEY of Fixer:"
api_key = get_password
puts "\n\n"

def convert_or_know_exchange_rate(api_key)
    uri = URI("http://data.fixer.io/api/latest?access_key=#{api_key}&base=EUR")
    response = Net::HTTP.get(uri)

    begin
        parsed_response = JSON.parse(response)
    rescue JSON::ParserError
        puts "Error parsing the API response. Please check your API key and try again."
        return
    end

    if parsed_response.key?('rates')
        rates = parsed_response['rates']

        prompt = TTY::Prompt.new
        currencies = ['BRL','USD','BTC','EUR']
        select = prompt.select("Select your base currency:", currencies)
        puts "\n"
        prompt1 = TTY::Prompt.new
        select1 = prompt1.select("select the currency to be converted:", currencies)
        puts "Put amount of currency (to unit value put 1): "
        amount = gets.chomp.to_i

        if rates.key?(select) && rates.key?(select1)    
            if rates[select] == rates['EUR'] 
            converted_amount = (rates[select] * rates[select1]) * amount
            else
                converted_amount = (rates[select] / rates[select1]) * amount
            end
            puts "Convertion: #{converted_amount}"
        else
            puts "Invalid or incomplete response from the API. Please check your API key and try again."
        end
    else
        puts "API returned an error: #{parsed_response['error']['info']}"
    end
end

loop do
    convert_or_know_exchange_rate(get_password)

    puts "Do you want to perform another conversion? (y/n): "
    response = gets.chomp.downcase
    break unless response == 'y'
end