require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

issuance_stream = '14mIMbJM'
transfer_stream = 'uZTTTg9B'

number_of_days = 1

raw_data = get_cc_tx_last_days(number_of_days-1)

p issuance_raw_data = raw_data.select{|d| d[:type] == 'issuance'}
p transfer_raw_data = raw_data.select{|d| d[:type] == 'transfer'}

issuance_data = group_by_hour(issuance_raw_data)
transfer_data = group_by_hour(transfer_raw_data)

parsed_issuance_data = issuance_data.map do |k,v|	
	hash = {"number" => v.count, "timestamp" => Time.parse(k).to_i}
	JSON.parse(hash.to_json)
end
parsed_transfer_data = transfer_data.map do |k,v|	
	hash = {"number" => v.count, "timestamp" => Time.parse(k).to_i}
	JSON.parse(hash.to_json)
end

p parsed_issuance_data
UPDATE.clear(issuance_stream)
UPDATE.push_line(issuance_stream,parsed_issuance_data)

p parsed_transfer_data
UPDATE.clear(transfer_stream)
UPDATE.push_line(transfer_stream,parsed_transfer_data)