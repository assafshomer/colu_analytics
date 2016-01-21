require 'spec_helper'
require __dir__+'/../setup.rb'

require __dir__+'/../helpers/explorer_helper.rb'
include ExplorerHelper

describe "HeadersHelper" do
	describe 'number_of_cc_tx_by_dates' do
		let(:expected) { [{"from"=>1452376800000, "untill"=>1452463200000, "txsSum"=>477}, {"from"=>1452463200000, "untill"=>1452549600000, "txsSum"=>216}, {"from"=>1452549600000, "untill"=>1452636000000, "txsSum"=>268}, {"from"=>1452636000000, "untill"=>1452722400000, "txsSum"=>98}, {"from"=>1452722400000, "untill"=>1452808800000, "txsSum"=>106}] }
	  it 'should return the integer time representations' do
			number_of_cc_tx_by_dates('10/01/2016','14/01/2016').should == expected
	  end
	end
	describe 'total_number_of_cc_tx_by_days' do
		it 'return correct nuber' do
			total_number_of_cc_tx_by_days(1).should be_a(Integer)
		end
	end

	describe 'get_cc_tx_last_days' do
		it 'should return a json' do
			get_cc_tx_last_days.should be_a(Array)
		end
		# it 'first element should have keys' do			
		# 	get_cc_tx_last_days.should be_nil
		# end		
		it 'first element should have keys' do			
			get_cc_tx_last_days.first.keys.sort.should == [:asset_ids,:time,:type]
		end
		it 'default should only include tx in one day' do
			dates = get_cc_tx_last_days.map do |data|
				Time.at(data[:time]/1000).strftime("%d/%m/%Y")
			end.uniq			
			dates.count.should == 1
		end
		it 'limit 1 should include tx from two days' do
			dates = get_cc_tx_last_days(1).map do |data|
				Time.at(data[:time]/1000).strftime("%d/%m/%Y")
			end.uniq
			p dates			
			dates.count.should == 2
		end
		it 'limit 1 should include tx from two days' do
			dates = get_cc_tx_last_days(2).map do |data|
				Time.at(data[:time]/1000).strftime("%d/%m/%Y")
			end
			p dates
			dates.uniq.count.should == 3
		end		
		# it 'limit 1 should include tx from two days' do
		# 	get_cc_tx_last_days(1).group_by{|x| Time.at(x[:time]/1000).strftime("%d/%m/%Y")}.count.should == 2
		# end		
	end


end