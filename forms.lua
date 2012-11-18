-- Some higher level forms examples, 06. Apr 2012
-- @nodepond / @dingfabrik, m.wisniowski

require("luacrumbs")

luacrumbs.generateGCode(true)
luacrumbs.generateSVG(true)

luacrumbs.init("forms")

luacrumbs.pencilUp()
--luacrumbs.moveTo(350,250)

--luacrumbs.setRotation(0)
--luacrumbs.pencilDown()

function circleFromLines(_x, _y, _radius, _numberOfPoints)
	if _numberOfPoints < 2 then _numberOfPoints = 2 end
	if _numberOfPoints > 360 then _numberOfPoints = 360 end

	-- make sure, that we work with integers
	local numPoints = math.floor(_numberOfPoints)

	luacrumbs.pencilUp()
	luacrumbs.moveTo(math.sin(math.rad(0*360/numPoints))*_radius+_x, 
					 math.cos(math.rad(0*360/numPoints))*_radius+_y)
	for i=0, numPoints do
		luacrumbs.lineTo(math.sin(math.rad(i*360/numPoints))*_radius+_x, 
						 math.cos(math.rad(i*360/numPoints))*_radius+_y)
	end
end
	
function make90DegreeCurve(_x, _y, _strokeLength, _rotation)
	luacrumbs.moveTo(_x, _y)
	-- buffer rotation
	local rot = luacrumbs.getRotation()
	
	if (_rotation < 0) then
		repeat
			luacrumbs.moveForward(_strokeLength)
			luacrumbs.addRotation(_rotation)
		until luacrumbs.getRotation() >= rot-90
		-- constrain to plain 90 degrees
		luacrumbs.setRotation(rot-90)
	else
		repeat
			luacrumbs.moveForward(_strokeLength)
			luacrumbs.addRotation(_rotation)
		until luacrumbs.getRotation() >= rot+90
		-- constrain to plain 90 degrees
		luacrumbs.setRotation(rot+90)
	end
end

function rect(_x, _y, _width, _height)
	luacrumbs.pencilUp()
	luacrumbs.moveTo(_x, _y)
	-- buffer rotation
	local rot = luacrumbs.getRotation()
	luacrumbs.pencilDown()
	luacrumbs.moveForward(_width)
	luacrumbs.addRotation(90)
	luacrumbs.moveForward(_height)
	luacrumbs.addRotation(90)
	luacrumbs.moveForward(_width)
	luacrumbs.addRotation(90)
	luacrumbs.moveForward(_height)
	-- rollBack rotation
	luacrumbs.setRotation(rot)
end

function circ(_x, _y, _length, _rotation)
	luacrumbs.pencilUp()
	luacrumbs.moveTo(_x, _y)
	luacrumbs.pencilDown()
	
	-- buffer rotation
	local rot = luacrumbs.getRotation()
	
	repeat
		luacrumbs.moveForward(_length)
		luacrumbs.addRotation(_rotation)
	until luacrumbs.getRotation() >= rot+360
		
	-- rollBack rotation
	luacrumbs.setRotation(rot)
end

function drawRoundRect()
	make90DegreeCurve(luacrumbs.getX(), luacrumbs.getY(), 2, 7)
	luacrumbs.moveForward(350)
	make90DegreeCurve(luacrumbs.getX(), luacrumbs.getY(), 2, 7)
	luacrumbs.moveForward(250)
	make90DegreeCurve(luacrumbs.getX(), luacrumbs.getY(), 2, 7)
	luacrumbs.moveForward(350)
	make90DegreeCurve(luacrumbs.getX(), luacrumbs.getY(), 2, 7)
	luacrumbs.moveForward(250)
end

--luacrumbs.moveTo(0, 0)

--luacrumbs.pencilDown()
--

--circleFromLines(25, 25, 10, 10)
--circleFromLines(50, 25, 18, 10)
--circleFromLines(50, 25, 18, 3)
--circleFromLines(150, 25, 18, 3000)


--local r = 62

--drawRoundRect()


--luacrumbs.addRotation(r)
--drawRoundRect()
--luacrumbs.addRotation(r)
--drawRoundRect()
--luacrumbs.addRotation(r)
--drawRoundRect()
--luacrumbs.addRotation(r)
--drawRoundRect()
--luacrumbs.addRotation(r)
--drawRoundRect()
--luacrumbs.addRotation(r)

--rect(120, 80, 400, 300)
-- circ(180, 150, 3, 4)

--luacrumbs.pencilUp()
--luacrumbs.close()
