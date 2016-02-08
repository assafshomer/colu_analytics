require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

issuance_stream = '14mIMbJM'
transfer_stream = 'uZTTTg9B'

number_of_days = 7

raw_data = get_cc_tx_last_days(limit: number_of_days-1)

p issuance_raw_data = raw_data.select{|d| d[:type] == 'issuance'}
p transfer_raw_data = raw_data.select{|d| d[:type] == 'transfer'}

issuance_data = group_by_day(issuance_raw_data)
transfer_data = group_by_day(transfer_raw_data)

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

# {"21/01/2016"=>[{:time=>1453378329229, :type=>"issuance", :asset_ids=>["LD2rcHjrxtx2UdSQMWin42ZNdh9ceKNtHen3S"]}, {:time=>1453378128304, :type=>"issuance", :asset_ids=>["U5tx22Tf21Y3JWS5mo8SqVAm8foQWTQNiXcE1"]}, {:time=>1453377788627, :type=>"issuance", :asset_ids=>["LJjLHKE9whAbXZoJ6GmjWeV8RnhkzcsiNXbrH"]}, {:time=>1453377723000, :type=>"issuance", :asset_ids=>["U3ydMFT1NF3Lk2S6TCSKvmip1T1cqTGwu4xUg"]}, {:time=>1453377029000, :type=>"issuance", :asset_ids=>["LF1ajz6C1pRvWEFpTd8Ufuxkp7mRZ3UTUjeRy"]}, {:time=>1453372437000, :type=>"issuance", :asset_ids=>["LCCE9cZMQaPEtrYwmK6NkxfzCQWgGUXmeRLFz"]}, {:time=>1453368976000, :type=>"issuance", :asset_ids=>["LJSqNonU5Ys2BfShmjHnkxQmkfBTCgLa372PD"]}, {:time=>1453368976000, :type=>"issuance", :asset_ids=>["LDEjq1nR7FaxLUSdS2nyMWp2WX4EfWrQNDh2s"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LD8pwF1w6aFv3mwi8JRKKdCypi6aFqQ6xZ1tW"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LKRY8eK3vi9Q2EMHDZJwAcwFHZXDTmR1yjzZ4"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LHVUoHjt7jwLWxVuedVwthfahLyMBFCpetYQP"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LGEUgLgxYF3r7vsaWMYf81td4qVwyktRSvfju"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LGA2jeCE2xX7e9Nezp8zwwtSgphhCt98r8yVE"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LErXQqF5EYreKyt3xi5a9J5aUSDVDxaJcjztM"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LJ27fWRtbVY7Tmn622uotAS7tMotrcAKWdgu9"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LGMwhTFE1nqp525SG48KvZYXrnbc6S8yRqsCe"]}, {:time=>1453368884000, :type=>"issuance", :asset_ids=>["LDZP8hn2bYLjFfRff3qwhiDudkspawcqqYRRM"]}, {:time=>1453365425000, :type=>"issuance", :asset_ids=>["LGDygu4zkBnK97tbZiRevJ64GQ6QoBSgTspem"]}, {:time=>1453365425000, :type=>"issuance", :asset_ids=>["LFtmHZe9S9Gn774y1f2VUFeJU648tEaJ8vrhQ"]}, {:time=>1453361749000, :type=>"issuance", :asset_ids=>["LCpsdRvX8S2S5iHqSQmeNL4NkXcsuYg8MsW2s"]}, {:time=>1453361749000, :type=>"issuance", :asset_ids=>["LHWJPNaz5c1LKNYqp8mbFDBZAcWBu1VfxwCL9"]}, {:time=>1453357366000, :type=>"issuance", :asset_ids=>["LKCoNyMjzB45HzYpvov5iVunWAeUQmgwFEzQw"]}, {:time=>1453349802000, :type=>"issuance", :asset_ids=>["LDkKcFWoafpg3PuH2oj65LuyQBGq1xK9p7r3i"]}, {:time=>1453347676000, :type=>"issuance", :asset_ids=>["LK2HRM8tAs3yC8xQKrsGyyJEH8crpEG7qw4Se"]}, {:time=>1453345221000, :type=>"issuance", :asset_ids=>["U4dK2fFvxSPNBdoaVwkd8oKy2tMo32QYfBmww"]}, {:time=>1453345221000, :type=>"issuance", :asset_ids=>["LCCdv2Q1GFHgW162JpKFvWFJdSu2zWDU7QkR3"]}, {:time=>1453339477000, :type=>"issuance", :asset_ids=>["LGe2cqfr6wXL8PFsHn3bkNWChDAzFmmrNgD1x"]}, {:time=>1453338457000, :type=>"issuance", :asset_ids=>["LDZq3ahxfTgmXJ8vrWcJcxfwtJHb2JegjbLkz"]}, {:time=>1453328922000, :type=>"issuance", :asset_ids=>["LGxYf2wE7swKFQvkx3qor7Pdb5zvcNHE89Xmx"]}]}