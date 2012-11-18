local lc = require ("luacrumbs")
require("Pde")
require("Html3D")

local pde = Pde.new()
local html3d = Html3D.new()

lc.addFormat(pde)
lc.addFormat(html3d)
--lc.addFormat(hpgl)
lc.init("hello-core")

pde:inspect() -- print Pde-format-infos to console 

for i=1,10 do
	lc.moveTo(i*10,i*10)
	lc.pencilUp()
	lc.moveTo(i*10,0)
	lc.pencilDown()
	lc.moveTo(i*-10,i*5)
end
lc.pencilUp()

lc.moveTo(0,0)
lc.pencilDown()
for i=1,10 do
	lc.moveForward(20)
	lc.pencilUp()
	lc.moveBackward(10)
	lc.pencilDown()
	lc.addRotation(15)
end

lc.setSpeed(100)
lc.pause(2)
lc.pencilUp()

lc.close()