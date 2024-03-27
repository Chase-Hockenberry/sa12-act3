require 'httparty'
require 'json'

class TicketmasterEvents
  include HTTParty
  base_uri 'https://app.ticketmaster.com/discovery/v2'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_events(location)
    response = self.class.get("/events.json?apikey=#{@api_key}&locale=*#{location}*")
    JSON.parse(response.body)
  end

  def display_events(events)
    if events['_embedded'] && events['_embedded']['events']
      events['_embedded']['events'].each do |event|
        puts "Name: #{event['name']}"
        puts "Description: #{event['info']}"
        puts "Venue: #{event['_embedded']['venues'][0]['name']}"
        puts "Location: #{event['_embedded']['venues'][0]['address']['line1']}, #{event['_embedded']['venues'][0]['city']['name']}, #{event['_embedded']['venues'][0]['state']['name']}, #{event['_embedded']['venues'][0]['country']['name']}"
        puts "Date: #{event['dates']['start']['localDate']}"
        puts "Time: #{event['dates']['start']['localTime']}"
            end
        end
    end
end

api_key = 'j8uHGRGvtChGu2ZC59q3Pmg7PsI7HaDU'
location = 'Memphis'

ticketmaster_events = TicketmasterEvents.new(api_key)
events = ticketmaster_events.fetch_events(location)

puts "Upcoming Events in #{location}:"
ticketmaster_events.display_events(events)
