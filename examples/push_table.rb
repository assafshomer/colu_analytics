require __dir__+'/../setup'
require __dir__+'/../helpers/newrelic_helper'
include NewrelicHelper
include ViewsHelper

stream = 'xLpTTCGk'

header_row = ["Metric", "Android", "Ios"]
table_rows = [["Active Users", 37, 1], ["Send 2 Address", "7.0 sec", "3.5 sec"], ["Send 2 Phone", "0.0 sec", "--"],['foo'], ["Sync Contacts", "2.4 sec", "--"]]

UPDATE.clear(stream)
UPDATE.push_table stream, header_row, table_rows


