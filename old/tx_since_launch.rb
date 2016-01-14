require './setup'
require './leftronic_helper'
STREAM = 'H2L1ArR6'

# Number of tx in last 24 hours

num_of_days = 365
ms_in_hour = 1000 * 60 * 60
duration_ms = ms_in_hour * 24 * num_of_days
end_time = Time.now.to_i*1000
start_time = end_time - duration_ms
group_by_number_of_hours = 24 * 31
bucket_ms = ms_in_hour * group_by_number_of_hours

raw_tx_data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

data = raw_tx_data.parsed_response.map{|d| {"number" => d["txsSum"].to_i, "timestamp" => d["from"].to_i/1000 }}

p data
nice_data = data.to_s.strip.gsub('=>',':').gsub(' ','')
p nice_data
data_cmd = %Q{#{CURL} '{"accessKey": "#{KEY}", "streamName": "#{STREAM}", "point": #{nice_data} }' #{URL}}
clear_cmd = %Q{#{CURL} '{"accessKey": "#{KEY}", "streamName": "#{STREAM}", "command": "clear" }' #{URL}}

system clear_cmd
system data_cmd

