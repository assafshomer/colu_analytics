require '../../setup'

stream = 'hGiAS5D6'

point = {"matrix":[["Years","Barcelona","Real Madrid","Atlético"],["2010",95,102,62],["2011",114,121,53],["2012",115,103,65],["2013",100,104,77]]}

UPDATE.clear(stream)
UPDATE.push_line(stream,point)
