require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

curdate = Time.at(Time.now.to_i)
curdate = Time.parse('2016-02-01')
number_of_results = 9999
method = "Live.getLastVisitsDetails"
raw = piwik_data_during_day(curdate, method: method, debug: false,limit: number_of_results)

visits = JSON.parse(raw)

asset_data = parse_visits(visits)

# general_data.each do |dp|
# 	puts "\n"
# 	p dp
# end

# asset_visits = general_data.select{|visit| visit.keys.include?(:asset_id) && visit[:asset_id] == 'U6CvmvnoaGaW6A16LoGbtBYRHJXiJHHWX6j3e' }

asset_id = 'U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE'

p pick_piwik_data_for_asset_id(asset_data,asset_id)


=begin
{:id=>11596, :ip=>"80.12.58.53", :country=>"France", :city=>nil, :flag=>"plugins/UserCountry/images/flags/fr.png", :asset_id=>"U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE", :user=>"adli%40me.com"}

=end