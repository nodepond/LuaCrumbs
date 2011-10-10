-- Another nice first-testfile with some random-fun.
-- Just something to play with.
-- Sep/Okt 2011 / martin wisniowski

require("particles")

particles.init("rnd.ngc")
particles.generateHTML(true)

for i=0, 100 do
	particles.line(math.random(20), math.random(20), math.random(40)+100, math.random(40))
	particles.circleAt(math.random(100), math.random(100), math.random(100))
	--particles.circleAt(100, 50)
end

particles.close()