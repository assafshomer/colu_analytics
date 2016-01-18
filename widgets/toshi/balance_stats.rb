require __dir__+'/../../setup'

def toshi_api(network)	
	case network.to_sym
	when :mainnet
		return 'https://bitcoin.toshi.io/api/v0/'
	else
		return 'https://testnet3.toshi.io/api/v0/'
	end	
end

mainnet_address_url = toshi_api(:mainnet)+'addresses/'+APP_CONFIG['mainnet_prod_address']
testnet_address_url = toshi_api(:testnet)+'addresses/'+APP_CONFIG['testnet_prod_address']


mainnet_balance = HTTParty.get(mainnet_address_url).parsed_response['balance']
testnet_balance = HTTParty.get(testnet_address_url).parsed_response['balance']

mainnet_balance_pretty = (mainnet_balance.to_f/100000000).round(3)
testnet_balance_pretty = (testnet_balance.to_f/100000000).round(3)

# stream = '1UlCOuWs' #  table
stream = 'Nb4mF19w' # leaderboard

# # Finance Balances
# header_row = ["Mainnet", mainnet_balance_pretty]
# table_rows = [
#   ["Testnet", testnet_balance_pretty]
# ]
# UPDATE.push_table stream, header_row, table_rows

point = {"leaderboard": [{"name": "Mainnet", "value": mainnet_balance_pretty}, {"name": "Testnet", "value": testnet_balance_pretty}]}

UPDATE.clear(stream)
UPDATE.push_line(stream,point)
