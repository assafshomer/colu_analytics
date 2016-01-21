require 'spec_helper'
require __dir__+'/../helpers/date_helper.rb'

include DateHelper

describe "DateHelper" do
	describe 'dates_are_numbers' do
	  it 'should return the integer time representations' do
			dates_are_numbers('14/01/2016','19/01/2016').should == {:from=>1452722400000, :till=>1453240800000} 	  	
	  end
	  it 'should return correctly' do
	  	dates_are_numbers('10/01/2016','14/01/2016').should == {:from=>1452376800000, :till=>1452808800000}
	  end
	end
	describe 'days_are_numbers' do
		it 'by default should span current 24h' do
			x = days_are_numbers
			(x[:till] - x[:from]).should == 1000*3600*24
			Time.at(x[:from]/1000).strftime("%d/%m/%Y").should == Time.now.strftime("%d/%m/%Y")
			Time.at(x[:till]/1000).strftime("%d/%m/%Y").should == (Time.now + 3600*24).strftime("%d/%m/%Y")			
		end
		it 'with limit should span limit days in past untill tonight full days' do
			x = days_are_numbers(1)
			(x[:till] - x[:from]).should == 1000*3600*24*2
			Time.at(x[:from]/1000).strftime("%d/%m/%Y").should == (Time.now - 3600*24).strftime("%d/%m/%Y")
			Time.at(x[:till]/1000).strftime("%d/%m/%Y").should == (Time.now + 3600*24).strftime("%d/%m/%Y")
		end
		it 'with limit and offset should span limit days in past untill midnight of offset days in the past' do
			x = days_are_numbers(1,1)
			(x[:till] - x[:from]).should == 1000*3600*24*2
			Time.at(x[:from]/1000).strftime("%d/%m/%Y").should == (Time.now - 3600*24*2).strftime("%d/%m/%Y")
			Time.at(x[:till]/1000).strftime("%d/%m/%Y").should == (Time.now).strftime("%d/%m/%Y")
		end		
	end
	# in web console
	# new Date(1452722400000)
	# Thu Jan 14 2016 00:00:00 GMT+0200 (IST)
	# new Date(1453240800000)
	# Wed Jan 20 2016 00:00:00 GMT+0200 (IST)	
end