-- Some higher level forms, 06. Apr 2012
-- @nodepond / @dingfabrik, m.wisniowski

function circleFromLines(_x, _y, _radius, _numberOfPoints)
	if _numberOfPoints < 2 then _numberOfPoints = 2 end
	if _numberOfPoints > 360 then _numberOfPoints = 360 end

	-- make sure, that we work with integers
	local numPoints = math.floor(_numberOfPoints)

	luacrumbs.pencilUp()
	luacrumbs.moveTo(math.sin(math.rad(0*360/numPoints))*_radius+_x, 
					 math.cos(math.rad(0*360/numPoints))*_radius+_y)
	luacrumbs.pencilDown()
	for i=0, numPoints do
		luacrumbs.moveTo(math.sin(math.rad(i*360/numPoints))*_radius+_x, 
						 math.cos(math.rad(i*360/numPoints))*_radius+_y)
	end
end

function triangle(_x1, _y1, _x2, _y2, _x3, _y3)
	luacrumbs.moveTo(_x1, _y1)
	luacrumbs.moveTo(_x2, _y2)
	luacrumbs.moveTo(_x3, _y3)
	luacrumbs.moveTo(_x1, _y1)
end