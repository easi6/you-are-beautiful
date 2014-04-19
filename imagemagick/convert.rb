faces = "people.jpg"
result = "result.jpg"

size = "100x64"
x = "+190"
y = "+145"
merged = "beautiful-0.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{faces} #{result}`

size = "60x10"
x = "+210"
y = "+225"
merged = "ugly-0.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`

size = "50x50"
x = "+330"
y = "+235"
merged = "ugly-1.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`

size = "100x71"
x = "+360"
y = "+165"
merged = "beautiful-1.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`

size = "100x74"
x = "+440"
y = "+155"
merged = "beautiful-2.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`

size = "100x94"
x = "+580"
y = "+125"
merged = "beautiful-3.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`

size = "80x80"
x = "+685"
y = "+160"
merged = "ugly-2.png"
`composite -geometry #{size}#{x}#{y} #{merged} #{result} #{result}`
