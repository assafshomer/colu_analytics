require '../setup'

point = {"chart": [{"name": "Cheryl", "value": 57, "color": "yellow"}, {"name": "Megan", "value": 32, "color": "blue"}, {"name": "Marisa", "value": 23, "color": "red"}]}

UPDATE.clear(stream)
UPDATE.push_line(stream,point)
