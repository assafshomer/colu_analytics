dirname = "widgets"

only_run_me = [
	'main_stats',
	'tx_last_24h',
	'tx_since_launch_by_month',
	'tx_last_week',
	'balance_stats',
	'machine_stats',
	'piwik_transmit_last_week',
	'piwik_mobile_send_last_week',
	'piwik_build_finance_last_week'
	]


all_widgets = Dir["#{dirname}/**/*.rb"]

widgets = only_run_me.map do |desired_widget|
	all_widgets.select{|widget| widget =~ /#{desired_widget}/}
end.flatten

# all_widgets.each{|w| p w}
# p "*"*20
# widgets.each{|w| p w}

widgets.each do |widget|
	p "#{widget.split('/').last.split('.').first} starting"
	load widget
	p "#{widget.split('/').last.split('.').first} done"
end
