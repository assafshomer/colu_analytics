require __dir__+'/helpers/views_helper'
include ViewsHelper

dirname = "widgets"

active_widgets = %w(	
	asset_leaderboard
	ios_timing
	android_timing
	issue_vs_send_since_midnight	
	issue_vs_send_since_midnight_testnet
	main_stats 
	monthly_cc_tx
	balance_stats
	machine_stoplights
	tx_last_week
	piwik_transmit_last_week
	piwik_mobile_send_last_week
	piwik_countries_today
)

all_widgets = Dir["#{dirname}/**/*.rb"]

widgets = active_widgets.map do |desired_widget|
	all_widgets.select{|widget| widget =~ /#{desired_widget}\.rb/}
end.flatten

widgets.each do |widget|
	starting = "#{widget.split('/').last.split('.').first} starting"
	ending = "#{widget.split('/').last.split('.').first} done"
	print_box starting
	load widget
	print_box ending
end


=begin
	new_asset_leaderboard
	ios_timing
	android_timing
	last_24h	
	main_stats 
	monthly_cc_tx
	balance_stats
	machine_stoplights
	tx_last_week
	piwik_transmit_last_week
	piwik_mobile_send_last_week
	piwik_countries_today
=end