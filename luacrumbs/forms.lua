-- Some higher level forms, 06. Apr 2012
-- @nodepond / @dingfabrik, m.wisniowski

module(..., package.seeall)

function circleFromLines(lc, _x, _y, _radius, _numberOfPoints)
	if _numberOfPoints < 2 then _numberOfPoints = 2 end
	if _numberOfPoints > 360 then _numberOfPoints = 360 end

	-- make sure, that we work with integers
	local numPoints = math.floor(_numberOfPoints)

	lc.pencilUp()
	lc.moveTo(math.sin(math.rad(0*360/numPoints))*_radius+_x, 
					 math.cos(math.rad(0*360/numPoints))*_radius+_y)
	lc.pencilDown()
	for i=0, numPoints do
		lc.moveTo(math.sin(math.rad(i*360/numPoints))*_radius+_x, 
						 math.cos(math.rad(i*360/numPoints))*_radius+_y)
	end
end

function triangle(lc, _x1, _y1, _x2, _y2, _x3, _y3)
	lc.moveTo(_x1, _y1)
	lc.moveTo(_x2, _y2)
	lc.moveTo(_x3, _y3)
	lc.moveTo(_x1, _y1)
end