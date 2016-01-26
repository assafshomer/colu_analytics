dirname = "widgets"

active_widgets = %w(	
	last_24h	
	main_stats 
	monthly_cc_tx
	balance_stats
	machine_stats
	tx_last_week
	piwik_transmit_last_week
	piwik_mobile_send_last_week	
)

all_widgets = Dir["#{dirname}/**/*.rb"]

widgets = active_widgets.map do |desired_widget|
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
