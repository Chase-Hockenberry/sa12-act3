require 'httparty'
require 'json'

class WeatherFetcher
  include HTTParty
  base_uri 'http://api.openweathermap.org/data/2.5'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_data(city)
    response = self.class.get("/weather?q=#{city}&appid=#{@api_key}&units=metric")
    JSON.parse(response.body)
  end

  def get_temp(city, hours)
    temperatures = []

    hours.times do |hour|
      response = self.class.get("/forecast?q=#{city}&appid=#{@api_key}&units=metric")
      data = JSON.parse(response.body)
    end

    temperatures
  end

  def calculation(city, hours)
    temperatures = get_temp(city, hours)
    average_temperature = temperatures.sum / temperatures.size.to_f
    average_temperature.round(2)
  end
end

api_key = '014030c41f8660005c096ff13bde94b7'
city = 'Memphis'
hours = 3

weather_fetcher = WeatherFetcher.new(api_key)
average_temperature = weather_fetcher.calculation(city, hours)

puts "Average temperature in #{city} over the last #{hours} hours: #{average_temperature}°C"