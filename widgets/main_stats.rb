require '../setup'

main_stats = HTTParty.get(EXPLORER_API+'getmainstats')

total_assets = main_stats.parsed_response['numOfAssets']
total_tx = main_stats.parsed_response['numOfCCTransactions']
total_holders = main_stats.parsed_response['numOfHolders']
# UPDATE.push_number 'CcDXTkhX', 6666

# Network stats
header_row = ["Category", "Total #"]
table_rows = [["Assets", total_assets],
    ["Txs", total_tx],["Holders",total_holders]]
UPDATE.push_table "19uDVxyt", header_row, table_rows

