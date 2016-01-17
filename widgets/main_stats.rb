require __dir__+'/../setup'

main_stats = HTTParty.get(EXPLORER_API+'getmainstats')

total_assets = main_stats.parsed_response['numOfAssets']
total_tx = main_stats.parsed_response['numOfCCTransactions']
total_holders = main_stats.parsed_response['numOfHolders']
# UPDATE.push_number 'CcDXTkhX', 6666

# Network stats
# header_row = ["Category", "Total #"]
# table_rows = [["Assets", total_assets],
#     ["Txs", total_tx],["Holders",total_holders]]
# UPDATE.push_table "19uDVxyt", header_row, table_rows

stream = '6c54e5cdfd'

point = {"leaderboard": [
	{"name": "Assets", "value": total_assets},
	{"name": "Tx", "value": total_tx},
	{"name": "Holders", "value": total_holders}
	]}

UPDATE.clear(stream)
UPDATE.push_line(stream,point)