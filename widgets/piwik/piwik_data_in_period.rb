require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

number_of_results = 9999
method = "Live.getLastVisitsDetails"
number_of_days = 1
days_offset = 3
raw = piwik_data_during_period(
	method: method, 
	debug: false,
	filter: number_of_results, 
	num_days: number_of_days -1,
	days_offset: days_offset
	)

visits = raw.class == String ? JSON.parse(raw) : raw

asset_data = parse_visits(visits)

# p asset_data
# asset_data.each do |dp|
# 	puts "\n"
# 	p dp
# end

# asset_visits = general_data.select{|visit| visit.keys.include?(:asset_id) && visit[:asset_id] == 'U6CvmvnoaGaW6A16LoGbtBYRHJXiJHHWX6j3e' }

asset_id = 'LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz'

p pick_piwik_data_for_asset_id(asset_data,asset_id)

# p pick_piwik_data_by_key(asset_data,{full_name: 'CryptoMoney1'})

=begin
{:id=>11596, :ip=>"80.12.58.53", :country=>"France", :city=>nil, :flag=>"plugins/UserCountry/images/flags/fr.png", :asset_id=>"U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE", :user=>"adli%40me.com"}
[{:piwik_id=>12372, :piwik_visitor=>"17f751cf2c1c467e", :ip=>"178.219.248.246", :country=>"Ukraine", :city=>nil, :flag=>"plugins/UserCountry/images/flags/ua.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}, {:piwik_id=>12367, :piwik_visitor=>"7aeecccf21c48339", :ip=>"178.73.192.202", :country=>"Sweden", :city=>nil, :flag=>"plugins/UserCountry/images/flags/se.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}, {:piwik_id=>12202, :piwik_visitor=>"8cec9dc904689695", :ip=>"178.219.248.246", :country=>"Ukraine", :city=>nil, :flag=>"plugins/UserCountry/images/flags/ua.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}, {:piwik_id=>12203, :piwik_visitor=>"4ecfd31909890c47", :ip=>"46.246.83.47", :country=>"Sweden", :city=>nil, :flag=>"plugins/UserCountry/images/flags/se.png", :asset_id=>"LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz"}]
=end