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
		describe 'matching with dates are numbers' do
		  let(:week_ago) { Time.at(Time.now.to_i - 3600*24*7).strftime("%d/%m/%Y") }
		  it 'should match' do
		  	dates_are_numbers(week_ago,nil).should == days_are_numbers(7)
		  end
		end
	end
	describe 'group_by_day' do
	  let(:ha) { [
	  	{time: Time.parse('01/01/2016 10:05').to_i*1000,foo: 1},
	  	{time: Time.parse('01/01/2016 11:06').to_i*1000,foo: 2},
	  	{time: Time.parse('01/01/2016 11:56').to_i*1000,foo: 3},
	  	{time: Time.parse('01/01/2015 10:05').to_i*1000,foo: 1}
	  	] }
	  it 'group_by_day' do
	  	group_by_day(ha).should == {"01/01/2016"=>[{:time=>1451635500000, :foo=>1}, {:time=>1451639160000, :foo=>2}, {:time=>1451642160000, :foo=>3}], "01/01/2015"=>[{:time=>1420099500000, :foo=>1}]}	  	
	  end
	  it 'group_by_hour' do
	  	group_by_hour(ha).should == {"01/01/2016 10:00"=>[{:time=>1451635500000, :foo=>1}], "01/01/2016 11:00"=>[{:time=>1451639160000, :foo=>2}, {:time=>1451642160000, :foo=>3}], "01/01/2015 10:00"=>[{:time=>1420099500000, :foo=>1}]}
	  end	  
	end
	describe 'hours_are_numbers' do
		let(:mask) { "%d/%m/%Y %H:%M" }
		it 'by default should span last 24h' do
			x = hours_are_numbers
			(x[:till] - x[:from]).should == 1000*3600*24
			Time.at(x[:till]/1000).strftime(mask).should == Time.now.strftime(mask)
			Time.at(x[:from]/1000).strftime(mask).should == (Time.now - 1.day).strftime(mask)
		end
		it 'with limit should span limit days in past untill tonight full days' do
			x = hours_are_numbers({limit: 1})
			(x[:till] - x[:from]).should == 1000*3600
			Time.at(x[:till]/1000).strftime(mask).should == Time.now.strftime(mask)
			Time.at(x[:from]/1000).strftime(mask).should == (Time.now - 1.hour).strftime(mask)
		end
		it 'with limit and offset should span limit days in past untill midnight of offset days in the past' do
			x = hours_are_numbers({limit: 2,offset: 3})
			(x[:till] - x[:from]).should == 1000*3600*2
			Time.at(x[:till]/1000).strftime(mask).should == (Time.now - 3.hour).strftime(mask)
			Time.at(x[:from]/1000).strftime(mask).should == (Time.now - 5.hour).strftime(mask)
		end
		# it 'should match days are numbers' do
		# 	hours_are_numbers.should == days_are_numbers
		# end
	end
	# in web console
	# new Date(1452722400000)
	# Thu Jan 14 2016 00:00:00 GMT+0200 (IST)
	# new Date(1453240800000)
	# Wed Jan 20 2016 00:00:00 GMT+0200 (IST)	
end