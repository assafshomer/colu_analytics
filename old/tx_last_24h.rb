require '../setup'

stream = 'GMgit0FL'

# Number of tx in last 24 hours
num_of_days = 1
ms_in_hour = 1000 * 60 * 60
duration_ms = ms_in_hour * 24 * num_of_days
end_time = Time.now.to_i*1000
start_time = end_time - duration_ms
group_by_number_of_hours = 1
bucket_ms = ms_in_hour * group_by_number_of_hours

raw_tx_data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

parsed_data = raw_tx_data.parsed_response.map do |d|
	hash = {"number" => d["txsSum"].to_i, "timestamp" => d["from"].to_i/1000 }
	JSON.parse(hash.to_json)
end

UPDATE.clear(stream)
UPDATE.push_line(stream,parsed_data)