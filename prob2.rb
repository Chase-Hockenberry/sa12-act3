require 'httparty'
require 'json'

class CurrencyConverter
  include HTTParty
  base_uri 'https://v6.exchangeratesapi.io/latest'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_exchange_rate(source_currency, target_currency)
    response = self.class.get("?base=#{source_currency}&symbols=#{target_currency}")
    data = JSON.parse(response.body)
    exchange_rate = data['rates'][target_currency]
    exchange_rate.nil? ? nil : exchange_rate.to_f
  end

  def convert_amount(amount, source_currency, target_currency)
    exchange_rate = fetch_exchange_rate(source_currency, target_currency)
    if exchange_rate.nil?
      puts "Failed to fetch exchange rate for #{source_currency} to #{target_currency}"
      return nil
    end
    converted_amount = amount * exchange_rate
    converted_amount.round(2)
  end
end

api_key = 'bd78fb29536b4d67ad797bb8'
currency_converter = CurrencyConverter.new(api_key)

amount = 100
source_currency = 'USD'
target_currency = 'EUR'

converted_amount = currency_converter.convert_amount(amount, source_currency, target_currency)
if converted_amount
  puts "#{amount} #{source_currency} is equivalent to #{converted_amount} #{target_currency}"
end
