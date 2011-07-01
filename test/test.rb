require '../lib/wiky'

s = Wiky.process(IO.read("input_complete"))

File.open("output.html", 'w') {|f| f.write(s) }
