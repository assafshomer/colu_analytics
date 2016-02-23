require '../../setup'

stream = 'rTnssN8J'

point = {"chart": [{"name": "Cheryl", "value": 57, "color": "yellow"}, {"name": "Megan", "value": 32, "color": "blue"}, {"name": "Marisa", "value": 23, "color": "red"}]}
point = {"chart": [{:name=>"February", :value=>28, :color=>"#00BDFF"}, {:name=>"January", :value=>5490, :color=>"#00BDFF"}, {:name=>"December", :value=>2774, :color=>"#7a7a7a"}]}


UPDATE.clear(stream)
UPDATE.push_line(stream,point)
