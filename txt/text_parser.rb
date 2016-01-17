require 'csv'

data = CSV.read(__dir__+'/piwik_page_titles.txt').flatten

result = data.map do |line|
	raw  = line.split("\t")
	[raw.first] if raw.first =~ /\./
end

# output_file = __dir__+'/piwik_mobile_calls_list.csv'
output_file = __dir__+'/piwik_page_titles.csv'

CSV.open(output_file, "w") do |csv|
	title = "page names from piwik"
  csv << [title.upcase]
  csv << ["*"*title.length ]
	result.compact.sort.each do |line|
		csv << line
	end
end