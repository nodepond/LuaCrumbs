-- This is the very first test of the framework
-- sep/okt 2011 / martin wisniowski

require("luacrumbs")

luacrumbs.generateSVG(true)
luacrumbs.generateHPGL(true)

luacrumbs.init("test", true)


-- jump straight into the fun!
luacrumbs.line(0, 0, 100, 100)
luacrumbs.line(0, 100, 100, 0)
luacrumbs.circleAt(50, 50, 12)

luacrumbs.setPencilDownPosition(-5)
luacrumbs.circleAt(50, 50, 12, true)
luacrumbs.setPencilDownPosition(-10)
luacrumbs.circleAt(50, 50, 8, true)

-- lineTo-example
luacrumbs.pencilUp()
luacrumbs.moveTo(20, 20)
luacrumbs.lineTo(80, 20)
luacrumbs.lineTo(80, 80)
luacrumbs.lineTo(20, 80)
luacrumbs.lineTo(20, 20)

luacrumbs.line(10, 10, 10, 50)
luacrumbs.line(15, 10, 15, 50)


-- just some more circles around the origin
luacrumbs.circleAt(0, 0, 50, true)
luacrumbs.circleAt(0, 0, 10, true)

luacrumbs.moveTo(0,0)
luacrumbs.circle(80)

luacrumbs.close()
