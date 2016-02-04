require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

number_of_results = 9999
method = "Live.getLastVisitsDetails"
number_of_days = 1
raw = piwik_data_during_period(method: method, debug: false,limit: number_of_results, offset: number_of_days -1)
visits = JSON.parse(raw)

asset_data = parse_visits(visits)

# p asset_data
# asset_data.each do |dp|
# 	puts "\n"
# 	p dp
# end

# asset_visits = general_data.select{|visit| visit.keys.include?(:asset_id) && visit[:asset_id] == 'U6CvmvnoaGaW6A16LoGbtBYRHJXiJHHWX6j3e' }

asset_id = 'LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz'

p pick_piwik_data_for_asset_id(asset_data,asset_id)

p pick_piwik_data_by_key(asset_data,{country: 'Sweden'})

=begin
{:id=>11596, :ip=>"80.12.58.53", :country=>"France", :city=>nil, :flag=>"plugins/UserCountry/images/flags/fr.png", :asset_id=>"U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE", :user=>"adli%40me.com"}

=end