require 'active_support/time'
require __dir__+'/../../helpers/date_helper'
include DateHelper

dan = days_are_numbers

# p "from: #{Time.at(dan[:from]/1000)}, till: #{Time.at(dan[:till]/1000)}"

# p "herenow :#{herenow}, #{Time.at(herenow)}"

# p "here"+(Time.now.strftime("%z").to_i/100).to_s
# p "Jer" +(Time.now.in_time_zone('Jerusalem').strftime("%z").to_i/100).to_s
# p "local time zone #{Time.now.getlocal.zone}"