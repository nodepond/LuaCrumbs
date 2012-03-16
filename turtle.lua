-- Very first "Turtle Test" - LOGO-like programming experience
-- Dec 2011 / Martin Wisniowski (@nodepond / @dingfabrik)

require("luacrumbs")

luacrumbs.generateGCode(false)
luacrumbs.generateHTML(true)
luacrumbs.generateSVG(false)
luacrumbs.generateHPGL(true)

luacrumbs.init("turtle")

luacrumbs.setRotation(0)

luacrumbs.setPencilUpPosition(30)

for i=0, 6 do
	luacrumbs.moveTo(220, 150)
	luacrumbs.pencilDown()
	for j=0, 240 do
		luacrumbs.moveForward(3+i)
		luacrumbs.addRotation(j-(120/2))
	end
	luacrumbs.addRotation(35)	
end

function drawCircle(x, y, step, rot)
	luacrumbs.moveTo(x, y)
	for i=0, 120 do
		luacrumbs.moveForward(step)
		luacrumbs.addRotation(rot+i)
	end
end

drawCircle(150, 150, 5, 0.1)
drawCircle(150, 150, 15, 0.1)

particles.close()
