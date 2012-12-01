-- formtest... testing forms.
-- m.wisniowski, @nodepond, 1.12.2012, Cologne

local lc = require ("luacrumbs")
require("forms")

require("Pde")
require("Html3D")

print("LuaCrumbs Version: "..tostring(lc.getVersion()))

lc.addFormat(Pde.new()) -- alternate way of directly adding CoreFormats
lc.addFormat(Html3D.new()) -- alternate way of directly adding CoreFormats
--lc.addFormat(Hpgl.new())

lc.init("formtest") -- ALWAYS DO THIS!

lc.pencilUp()
lc.triangle(0,0,10,10,0,10)
lc.moveTo(50,50)
lc.pencilDown()
lc.triangle(50+0,50+0,50+10,50+10,50+0,50+10)

lc.circleFromLines(50,50,50,8)
lc.circleFromLines(50,50,60,48)

lc.close() -- ALWAYS DO THIS!