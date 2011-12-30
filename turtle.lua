-- Very first "Turtle Test" - LOGO-like programming experience
-- Dec 2011 / Martin Wisniowski (@nodepond / @dingfabrik)

require("particles")

particles.init("turtle")
particles.generateGCode(true)
particles.generateHTML(true)
particles.generateSVG(true)

particles.moveTo(20, 20)
particles.lineTo(25, 25)

particles.setRotation(0)

--particles.moveForward(5)

for i=0, 20 do
	particles.pencilUp()
	particles.moveTo(100, 150)
	particles.moveForward(150)
	particles.addRotation(5)
end

particles.close()
