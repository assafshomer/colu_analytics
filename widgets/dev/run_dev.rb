require __dir__+'/../../helpers/views_helper'
include ViewsHelper

active_widgets = %w(	
	all_cc_tx_last_week_dev
	piwik_cc_transmit_last_week
)

all_widgets = Dir["#{__dir__}/*.rb"]

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