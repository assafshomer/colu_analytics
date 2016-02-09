require 'spec_helper'
require __dir__+'/../helpers/views_helper.rb'

include ViewsHelper

describe "ViewsHelper" do
	describe 'multi countries per asset' do
		let(:data) { [{:piwik_id=>12372, :piwik_visitor=>"17f751cf2c1c467e", :ip=>"178.219.248.246", :country=>"Ukraine", :city=>'foo', :flag=>"plugins/UserCountry/images/flags/ua.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}, {:piwik_id=>12367, :piwik_visitor=>"7aeecccf21c48339", :ip=>"178.73.192.202", :country=>"Sweden", :city=>'bar', :flag=>"plugins/UserCountry/images/flags/se.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}, {:piwik_id=>12202, :piwik_visitor=>"8cec9dc904689695", :ip=>"178.219.248.246", :country=>"Israel", :city=>'Tel-Aviv', :flag=>"plugins/UserCountry/images/flags/ua.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}] }
		describe 'multi countries title' do
		  it 'should list country, ip with newline' do
		  	create_multiline_title(data,[:country,:ip]).should == "COUNTRY: [Ukraine], IP: [178.219.248.246]&#013;&#xA;COUNTRY: [Sweden], IP: [178.73.192.202]&#013;&#xA;COUNTRY: [Israel], IP: [178.219.248.246]&#013;&#xA;"
		  end
		  it 'should create multi lines for multi hashes' do
		  	create_multiline_title([{foo: 1}, {bar: 2}],[:foo,:bar]).should == "FOO: [1]&#013;&#xA;BAR: [2]&#013;&#xA;"
		  end
		  it 'should create one line for one hash' do
		  	create_multiline_title([{foo: 1,bar: 2}],[:foo,:buzz]).should == "FOO: [1]&#013;&#xA;"
		  end		  
		end
		describe 'list of countries' do
		  it 'should list alpha2 of countries' do
		  	list_countries_alpha2(data).should == "UA,SE,IL"
		  end
		end
	  
	end


end