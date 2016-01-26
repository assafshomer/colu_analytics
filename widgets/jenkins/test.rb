require 'active_support/time'
require '../../helpers/date_helper'
include DateHelper

dan = days_are_numbers

p "from: #{Time.at(dan[:from]/1000)}, till: #{Time.at(dan[:till]/1000)}"