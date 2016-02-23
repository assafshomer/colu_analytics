require __dir__+'/helpers/views_helper'
include ViewsHelper

dirname = "widgets"

active_widgets = %w(
		##JENKINS##
	machine_stoplights
		##TOSHI##
	balance_stats
		##NEWRELIC##
	ios_timing
	android_timing
		##EXPLORER##
	main_stats
	monthly_cc_tx
	tx_last_week
	issue_vs_send_since_midnight
		##PIWIK##
	piwik_ccd_last_week
	piwik_countries_today
	piwik_mobile_send_last_week	
	piwik_transmit_last_week
		##EXPLORER_and_PIWIK##
	asset_leaderboard
)

all_widgets = Dir["#{dirname}/**/*.rb"]

active_widgets.select!{|w| w !~ /\#{2}\w*\#{2}/}

widgets = active_widgets.map do |desired_widget|
	all_widgets.select{|widget| widget =~ /#{desired_widget}\.rb/i}
end.flatten

widgets.each do |widget|
	starting = "#{widget.split('/').last.split('.').first} starting"
	ending = "#{widget.split('/').last.split('.').first} done"
	print_box starting
	load widget
	print_box ending
end
