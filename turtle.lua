-- Very first "Turtle Test" - LOGO-like programming experience
-- Dec 2011 / Martin Wisniowski (@nodepond / @dingfabrik)

require("particles")

particles.init("turtle")
particles.generateGCode(false)
particles.generateHTML(true)
particles.generateSVG(false)

particles.setRotation(0)

particles.setPencilUpPosition(30)

for i=0, 6 do
	particles.moveTo(220, 150)
	particles.pencilDown()
	for j=0, 120 do
		particles.moveForward(3+i)
		particles.addRotation(j-(120/2))
	end
--	particles.pencilUp()
--	particles.moveForward(150)
	particles.addRotation(45)	
end

particles.close()
