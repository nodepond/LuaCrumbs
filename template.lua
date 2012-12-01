local lc = require ("luacrumbs")
require("Pde")
require("Html3D")

--print("LuaCrumbs Version: "..tostring(lc.getVersion()))

local pde = Pde.new()

lc.addFormat(pde)

lc.addFormat(Html3D.new()) -- alternate way of directly adding CoreFormats
--lc.addFormat(Hpgl.new())

lc.init("template") -- ALWAYS DO THIS!
pde:inspect() -- print Pde-coreFormat-infos to console. Must be after lc.init

-- do your stuff here. 

--Example:
--lc.pencilUp()
--lc.moveTo(10,10)
--lc.pencilDown()
--lc.moveTo(20,20)

lc.close() -- ALWAYS DO THIS!