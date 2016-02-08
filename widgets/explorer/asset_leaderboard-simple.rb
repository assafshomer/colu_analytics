require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

assets_stream = 'aEu4sfdm'
number_of_assets = 6
number_of_days = 1
start_days_past = 0
debug = false
network = :mainnet

raw_data = get_cc_tx_last_days(limit: number_of_days-1,offset: start_days_past,debug: debug, network: network)

ordered_asset_ids = order_asset_ids(raw_data).first(number_of_assets)
p ordered_asset_ids
html = prepare_simple_asset_leaderboard(ordered_asset_ids)

UPDATE.push_html assets_stream, html