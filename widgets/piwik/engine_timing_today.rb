require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

number_of_results_to_show = 20
# method = "Live.getLastVisitsDetails"
method = "Actions.getPageTitles"
number_of_days_to_show = 1
raw = piwik_data_during_period(
	method: method, 
	debug: false,
	filter: number_of_results_to_show, 
	num_days: number_of_days_to_show-1
	)

white_list = ["label","avg_time_generation","min_time_generation","max_time_generation"]

relevant = raw.map do |dp|
	dp.select {|k,v| white_list.include?(k)}
end

sorted =  relevant.sort_by{|e| e["avg_time_generation"]}.reverse

stream = 'hGiAS5D6'

data_to_display = []
data_to_display << ["Methods","Avg","Min","Max"]
sorted.each do |dp|
	data_to_display << [dp['label'],dp['avg_time_generation'],dp['min_time_generation'],dp['max_time_generation']]
end

# point = {"matrix":[["Methods","Avg","Min","Max"],["2010",95.1,102,62],["2011",114,121,53],["2012",115,103,65],["2013",100,104,77]]}

point = {"matrix": data_to_display}

# p data_to_display

# UPDATE.clear(stream)
UPDATE.push_line(stream,point)















# data = JSON.parse(raw)

# asset_data = parse_visits(visits)

# p asset_data.count
# asset_data.each do |dp|
# 	puts "\n"
# 	p dp
# end

# asset_visits = general_data.select{|visit| visit.keys.include?(:asset_id) && visit[:asset_id] == 'U6CvmvnoaGaW6A16LoGbtBYRHJXiJHHWX6j3e' }

# asset_id = 'LHCaK3nnpmiHRHLAaSUtTXX3tyXt9DqTURsdr'

# p pick_piwik_data_for_asset_id(asset_data,asset_id)


=begin
{:id=>11596, :ip=>"80.12.58.53", :country=>"France", :city=>nil, :flag=>"plugins/UserCountry/images/flags/fr.png", :asset_id=>"U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE", :user=>"adli%40me.com"}

=end