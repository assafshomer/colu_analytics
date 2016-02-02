dirname = "widgets"

active_widgets = %w(
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
)

all_widgets = Dir["#{dirname}/**/*.rb"]

widgets = active_widgets.map do |desired_widget|
	all_widgets.select{|widget| widget =~ /#{desired_widget}/}
end.flatten

# all_widgets.each{|w| p w}
# p "*"*20
# widgets.each{|w| p w}

widgets.each do |widget|
	starting = "#{widget.split('/').last.split('.').first} starting"
	ending = "#{widget.split('/').last.split('.').first} done"
	wrapper = "*"*starting.length
	p wrapper
	p "***\t #{starting}\t ***"
	p wrapper
	load widget
	p wrapper
	p "***\t #{ending}\t ***"
	p wrapper
end
