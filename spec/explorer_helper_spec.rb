require 'spec_helper'
require __dir__+'/../setup.rb'

require __dir__+'/../helpers/explorer_helper.rb'
include ExplorerHelper

describe "HeadersHelper" do
	describe 'number_of_cc_tx_by_dates' do
		let(:expected) { [{"from"=>1452376800000, "untill"=>1452463200000, "txsSum"=>477}, {"from"=>1452463200000, "untill"=>1452549600000, "txsSum"=>216}, {"from"=>1452549600000, "untill"=>1452636000000, "txsSum"=>268}, {"from"=>1452636000000, "untill"=>1452722400000, "txsSum"=>98}, {"from"=>1452722400000, "untill"=>1452808800000, "txsSum"=>109}] }
	  it 'should return the integer time representations' do
			number_of_cc_tx_by_dates(start_day: '10/01/2016',end_day: '14/01/2016').should == expected
	  end
	end	
	describe 'total_number_of_cc_tx_by_days' do
		it 'return correct nuber' do
			total_number_of_cc_tx_by_days(limit: 1).should be_a(Integer)
		end
	end

	describe 'get_cc_tx_last_days' do
		it 'should return a json' do
			get_cc_tx_last_days.should be_a(Array)
		end	
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
			dates = get_cc_tx_last_days(limit: 1).map do |data|
				Time.at(data[:time]/1000).strftime("%d/%m/%Y")
			end.uniq
			dates.count.should == 2
		end
		it 'limit 2 should include tx from 3 days' do
			dates = get_cc_tx_last_days(limit: 2).map do |data|
				Time.at(data[:time]/1000).strftime("%d/%m/%Y")
			end
			dates.uniq.count.should == 3
		end
		it 'limit 6 should include tx from 7 days' do
			dates = get_cc_tx_last_days(limit: 6).map do |data|
				Time.at(data[:time]/1000).strftime("%d/%m/%Y")
			end
			dates.uniq.count.should == 7
		end		
		# it 'limit 1 should include tx from two days' do
		# 	get_cc_tx_last_days(1).group_by{|x| Time.at(x[:time]/1000).strftime("%d/%m/%Y")}.count.should == 2
		# end		
	end

	describe 'ordered asset ids' do
	  let(:raw_data) { [
	  	{:time=>1453587759477, :type=>"issuance", :asset_ids=>["a","b","z"]},
	  	{:time=>1453716035000, :type=>"transfer", :asset_ids=>["a","z"]},
	  	{:time=>1453716035000, :type=>"issuance", :asset_ids=>["a"]},
	  	{:time=>1453712336000, :type=>"transfer", :asset_ids=>["b","a"]},
	  	{:time=>1453712336000, :type=>"issuance", :asset_ids=>["b"]},
	  	{:time=>1453711100000, :type=>"issuance", :asset_ids=>["c"]}	  	 
	  	] }
	  	let(:ordered_asset_ids) { order_asset_ids(raw_data) }
	  it 'should order asset ids' do
	  	ordered_asset_ids.should == [{:a=>4}, {:b=>3}, {:z=>2}, {:c=>1}]
	  end
	  describe 'html' do
	  	it 'prepare the correct HTML' do
	  		prepare_simple_asset_leaderboard(ordered_asset_ids).should_not be_nil
	  	end
	  end
	end
	describe 'get_asset_name' do
		describe 'an asset with a name' do
			let(:aid) { 'LEL5H3V37xXRxZGdwhMXUYXrjnEa1xwmNS8rQ' }
			let(:metadata) { {"assetName"=>"Vallium", "issuer"=>"Dr. Rob OConner", "description"=>"1M mg of Vallium"} }
		  it 'should get the asset name from asset id' do
		  	get_asset_metadata(aid).should == metadata
		  end		  
		end
		describe 'an asset without a name' do
			let(:aid) { 'LE9mi9Da7urJcdawYLVFQPtScUR8rcggxYtub' }
		  it 'should return nil' do
		  	get_asset_metadata(aid).should be_nil
		  end		  
		end
	end




end