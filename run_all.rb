dirname = "widgets"

dont_run_me = [
	'tx_last_week',
	'piwik_engine_send_last_week'
	].map{|n| "#{dirname}/#{n}.rb"}
# only_run_me = ['main_stats','balance_stats'].map{|n| "#{dirname}/#{n}.rb"}
only_run_me = [].map{|n| "#{dirname}/#{n}.rb"}


widgets = Dir["#{dirname}/**/*.rb"]
widgets.reject!{|w| dont_run_me.include?(w)}
widgets.select!{|w| only_run_me.include?(w)} unless only_run_me.empty?

widgets.each do |widget|
	p "#{widget.split('/').last.split('.').first} starting"
	load widget
	p "#{widget.split('/').last.split('.').first} done"
end
