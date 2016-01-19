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
	  	get_transactions_last_days(1).should be_a(Integer)
	  end
	end

	describe 'get_transactions_last_days' do
	  it 'should return a json' do
	  	get_transactions_last_days.should be_nil
	  end
	end


end