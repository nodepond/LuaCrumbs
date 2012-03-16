-- Another nice first-testfile with some random-fun.
-- Just something to play with.
-- Sep/Okt 2011 / martin wisniowski

require("luacrumbs")

luacrumbs.init("rnd")
luacrumbs.generateHTML(true, 10)
-- luacrumbs.generateGCode(false) -- example to surpress GCode-output
luacrumbs.generateSVG(true)

for i=0, 40 do
	luacrumbs.line(math.random(20), math.random(20), math.random(40)+100, math.random(40))
	luacrumbs.circleAt(math.random(100), math.random(100), math.random(40))
	--luacrumbs.circleAt(100, 50)
end

luacrumbs.close()