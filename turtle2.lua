require("luacrumbs")

luacrumbs.generateGCode(false)
luacrumbs.generateHTML3D(true)
luacrumbs.generateSVG(false)
luacrumbs.generateHPGL(true)

luacrumbs.init("turtle2")

luacrumbs.setRotation(0)
luacrumbs.setPencilUpPosition(30)

function drawCircle(x, y, step, rot)
	luacrumbs.pencilUp()
	luacrumbs.moveTo(x, y)
	luacrumbs.pencilDown()	
	for i=0, 40 do
		luacrumbs.moveForward(step)
		luacrumbs.addRotation(rot+i)
	end
end

drawCircle(0, 0, 5, 0.1)
drawCircle(15, 15, 8, 0.1)
drawCircle(30, 30, 2, 0.3)
drawCircle(-45, 30, 6, 3.3)

luacrumbs.close()
