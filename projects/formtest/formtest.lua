-- formtest... testing forms.
-- m.wisniowski, @nodepond, 1.12.2012, Cologne

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

print("LuaCrumbs Version: "..tostring(lc.getVersion()))

lc.addFormat(Pde.new()) -- alternate way of directly adding CoreFormats
lc.addFormat(Html3D.new()) -- alternate way of directly adding CoreFormats
--lc.addFormat(Hpgl.new())

lc.init("formtest") -- ALWAYS DO THIS!

lc.pencilUp()
f.triangle(lc, 0,0,10,10,0,10)

lc.moveTo(50,50)
lc.pencilDown()

f.triangle(lc, 50+0,50+0,50+10,50+10,50+0,50+10)

f.circleFromLines(lc, 50,50,50,8)
f.circleFromLines(lc, 50,50,60,48)

lc.close() -- ALWAYS DO THIS!