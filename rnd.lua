-- Another nice first-testfile with some random-fun.
-- Just something to play with.
-- Sep/Okt 2011 / martin wisniowski

require("particles")

particles.init("rnd")
particles.generateHTML(true, 10)
-- particles.generateGCode(false) -- example to surpress GCode-output
particles.generateSVG(true)

for i=0, 40 do
	particles.line(math.random(20), math.random(20), math.random(40)+100, math.random(40))
	particles.circleAt(math.random(100), math.random(100), math.random(40))
	--particles.circleAt(100, 50)
end

particles.close()