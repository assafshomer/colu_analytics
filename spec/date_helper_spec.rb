require 'spec_helper'
require __dir__+'/../helpers/date_helper.rb'

include DateHelper

describe "HeadersHelper" do
	describe 'days_are_numbers' do
	  it 'should return the integer time representations' do
			days_are_numbers('14/01/2016','19/01/2016').should == {:from=>1452722400000, :till=>1453240800000} 	  	
	  end
	end
	# in web console
	# new Date(1452722400000)
	# Thu Jan 14 2016 00:00:00 GMT+0200 (IST)
	# new Date(1453240800000)
	# Wed Jan 20 2016 00:00:00 GMT+0200 (IST)	
end