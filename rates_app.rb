
require 'net/http'
require 'io/console'
require 'tty-prompt'
require 'json'
require_relative 'password'

system 'clear'

def convert_or_know_exchange_rate(api_key)
    #system 'clear'
    uri = URI("http://data.fixer.io/api/latest?access_key=#{api_key}&base=EUR")
    response = Net::HTTP.get(uri)

    begin
        parsed_response = JSON.parse(response)
    rescue JSON::ParserError
        puts "Error parsing the API response."
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
        #system 'clear'
        puts "API returned an error: #{parsed_response['error']['info']}"
    end
end

loop do
    system 'clear'
    title = "Convert or know exchange rate\n"
    t_up = title.upcase
    puts t_up
    puts "\nPut your API KEY of Fixer:"
    api_key = get_password
    puts "\n\n"
    convert_or_know_exchange_rate(api_key)
    prompt2 = TTY::Prompt.new
        option = ['YES','NO']
        question = "\nDo you want to try again?"
        question_up = question.upcase
    select2 = prompt2.select(question_up, option)
    break if select2 == 'NO'
end