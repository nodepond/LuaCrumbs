package.path = package.path..";../../?.lua"

local lc = require ("luacrumbs.luacrumbs")
local f = require("luacrumbs.forms")

require("luacrumbs.coreformats.Pde")
require("luacrumbs.coreformats.Html3D")

-- alternate declaring (which is nicer?):
--package.path = package.path..";../../luacrumbs/?.lua"

--local lc = require ("luacrumbs")
--local f = require("forms")

--require("coreformats.Pde")
--require("coreformats.Html3D")

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