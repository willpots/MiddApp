require 'net/http'
require 'icalendar'
class DataController < ApplicationController
  def fetch
    uri = URI('http://menus.middlebury.edu/menus/all/all/all/menu.ics')
    calendar = Net::HTTP.get(uri)
    cals = Icalendar.parse(calendar)
    cal = cals.first

    # Now you can access the cal object in just the same way I created it
    now = DateTime.now.midnight
    props = cal.events.select { |e|
      event_date = e.properties["dtstart"]
      event_date.day == now.day && event_date.year == now.year && event_date.month == now.month
    }.map { |e| 
      { 
        :location => e.properties["location"],
        :meal => e.properties["summary"],
        :description => remove_html(e.properties["description"])
      }
    }
    render json: props
  end



  private
  def remove_html(string)
    string.gsub("<p>","").gsub("</p>","").gsub("\\r","").split("<br />").map {|s| s.strip}

  end
end
