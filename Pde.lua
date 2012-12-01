-----------------------------------------------------------------------------
-- LuaCrumbs - pde (Processing) core implementation
-- http://luacrumbs.nodepond.com
--
-- License: MIT/X
-- 
-- (c) 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
--
-- Work started on this file on 11. June 2012 / THIS IS EXPERIMENTAL WORK ATM
-- First version 17. November 2012
-----------------------------------------------------------------------------

-- simple class constructor
Pde = {}
Pde.__index = Pde

function Pde.new()
   local pde = {}         
   setmetatable(pde,Pde)  				-- make Pde handle lookup
   --pde.projectname = projectname      	-- initialize object
   return pde
end

function Pde:init(_projectname)
	self.projectname = _projectname
	self.body = ""
end

function Pde:inspect()
	print("Pde inspect - projectname "..self.projectname)
end

function Pde:moveTo(_x, _y, _z, _pre_x, _pre_y, _pre_z)
	--print("Pde moveTo _x ".._x.." _y".._y)
	self.body = self.body.."line("..string.format("%.12f",_pre_x)..", "..string.format("%.12f",_pre_y)..", "..string.format("%.12f",_pre_z)..", "..string.format("%.12f",_x)..", "..string.format("%.12f",_y)..", "..string.format("%.12f",_z)..");\n"	
--	self.body = self.body.."line("..string.format("%.12f",_pre_x)..", "..string.format("%.12f",_pre_y)..", "..string.format("%.12f",curz)..", "..string.format("%.12f",xpos)..", "..string.format("%.12f",ypos)..", "..string.format("%.12f",zpos)..");\n"	
end

function Pde:setSpeed(_speed)
	print("Pde setSpeed _speed ".._speed)
end

function Pde:pause(_seconds)
	print("Pde pause ".._seconds)
end

function Pde:pencilUp(_isPencilUpAlreadyUp, _x, _y, _cur_z, _dest_z)
	print("Pde pencilUp "..tostring(_isPencilUpAlreadyUp))
	if (_isPencilUpAlreadyUp == 1) then
		-- do nothing
	else
		self.body = self.body.."stroke(120, 120, 200);\n"
		self:moveTo(_x, _y, _cur_z, _x, _y, _dest_z)
	end
end

function Pde:pencilDown(_isPencilUpAlreadyDown, _x, _y, _cur_z, _dest_z)
	print("Pde pencilDown "..tostring(_isPencilUpAlreadyDown))
	if (_isPencilUpAlreadyDown == 1) then
		-- do nothing
	else
		self:moveTo(_x, _y, _cur_z, _x, _y, _dest_z)
		self.body = self.body.."stroke(0, 0, 0);\n"
	end
end

function Pde:close()

	print("\nStarting to write processing Pde-file.")
	local output_file = self.projectname..".pde"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	
	file:write(self:getHeader())
	file:write(self:getBody())
	file:write(self:getFooter())
	
	print("Writing of "..output_file.." complete.\n")
end


function Pde:getHeader()
	self.header = "boolean isRotating = false;\n"
	self.header = self.header.."boolean isRotatingX = false;\n"
	self.header = self.header.."boolean isRotatingY = false;\n"
	self.header = self.header.."boolean isRotatingZ = true;\n"
	self.header = self.header.."boolean alternateColors = false;\n"
	self.header = self.header.."float incx = 0.;\n"
	self.header = self.header.."float incy = 0.;\n"
	self.header = self.header.."float incz = 0.;\n"
	self.header = self.header.."float middlex;\n"
	self.header = self.header.."float middley;\n"
	self.header = self.header.."float middlez;\n"
	self.header = self.header.."float rotX = 0.;\n"
	self.header = self.header.."float rotY = 0.;\n"
	self.header = self.header.."float rotZ = 0.;\n"
	self.header = self.header.."void setup() {\n"
	self.header = self.header.."	size(800, 600, OPENGL);\n"
	self.header = self.header.."	fill(184, 235, 184);\n"
	self.header = self.header.."}\n"
	
	self.header = self.header.."void drawCircle(float _x, float _y, float _radius, float _z) {\n"
	self.header = self.header.."_radius = _radius / 2;\n"
	self.header = self.header.."noFill();\n"
	self.header = self.header.."bezier(0 + _x, _radius/2 + _y, _z, 0 + _x, _radius/2 +_y, _z, 0+_x, 0+_y, _z, _radius/2+_x, 0+_y, _z);\n"
	self.header = self.header.."bezier(_radius/2 + _x, 0 + _y, _z, _radius/2 + _x, 0 + _y, _z, _radius + _x, 0 + _y, _z, _radius + _x, _radius/2 + _y, _z);\n"
	self.header = self.header.."bezier(_radius + _x, _radius/2 + _y, _z, _radius + _x, _radius/2 + _y, _z, _radius + _x, _radius + _y, _z, _radius/2 + _x, _radius + _y, _z);\n"
	self.header = self.header.."bezier(_radius/2 + _x, _radius + _y, _z, _radius/2 + _x, _radius + _y, _z, 0 + _x, _radius + _y, _z, 0 + _x, _radius/2 + _y, _z);\n"
	self.header = self.header.."}\n"
	self.header = self.header.."\n"
	self.header = self.header.."void draw() {\n"
	self.header = self.header.."	lights();\n"
	self.header = self.header.."	if (alternateColors) {\n"
	self.header = self.header.."		background(120);\n"
	self.header = self.header.."	} else {\n"
	self.header = self.header.."		background(255);\n"
	self.header = self.header.."	}\n"
	self.header = self.header.."	camera(0.0, middlez, 220.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);\n"
	self.header = self.header.."	if (mousePressed) {\n"
	self.header = self.header.."	// do nothing\n"
	self.header = self.header.."	} else {\n"
	self.header = self.header.."	rotY = (PI*2)*((mouseX/(float)width)+incx);\n"
	self.header = self.header.."	rotX = (PI*2)*((mouseY/(float)height)+incy);\n"
	self.header = self.header.."	rotZ = (PI*2)*incz;\n"
	self.header = self.header.."	}\n"
	self.header = self.header.."	translate(middlex, middley, 0.);\n"
	self.header = self.header.."	rotateX(rotX);\n"
	self.header = self.header.."	rotateY(rotY);\n"
	self.header = self.header.."	rotateZ(rotZ);\n"
	self.header = self.header.."	translate(-middlex, -middley, -0.);\n"
	self.header = self.header.."	\n"
	self.header = self.header.."	if (isRotating) {\n"
	self.header = self.header.."	if (isRotatingX) { incx += 0.0003; };\n"
	self.header = self.header.."		if (incx >= 1.0) {\n"
	self.header = self.header.."			incx = 0.;\n"
	self.header = self.header.."		}\n"
	self.header = self.header.."	if (isRotatingY) { incy += 0.0001; };\n"
	self.header = self.header.."		if (incy >= 1.0) {\n"
	self.header = self.header.."			incy = 0.;\n"
	self.header = self.header.."		}\n"
	self.header = self.header.."	if (isRotatingZ) { incz += 0.00045; };\n"
	self.header = self.header.."		if (incz >= 1.0) {\n"
	self.header = self.header.."			incz = 0.;\n"
	self.header = self.header.."		}\n"
	self.header = self.header.."	}\n"
	self.header = self.header.."	if (alternateColors) {\n"
	self.header = self.header.."		stroke(120, 0, 0);\n"
	self.header = self.header.."	} else {\n"
	self.header = self.header.."		stroke(40, 120, 40);\n"
	self.header = self.header.."	}\n"
	self.header = self.header.."	line(0, 0, 0, 100, 0, 0);\n"
	self.header = self.header.."	line(0, 0, 0, 0, 100, 0);\n"
	self.header = self.header.."	line(0, 0, 0, 0, 0, 100);\n"
	self.header = self.header.."	if (alternateColors) {\n"
	self.header = self.header.."		stroke(0);\n"
	self.header = self.header.."	} else {\n"
	self.header = self.header.."		stroke(0);\n"
	self.header = self.header.."	}\n"
	return self.header
end
function Pde:getBody()
	return self.body
end
function Pde:getFooter()
	self.footer = "	noStroke();\n"
	self.footer = self.footer.."	if (alternateColors) {\n"
	self.footer = self.footer.."		fill(180, 180, 180, 120);\n"
	self.footer = self.footer.."	} else {\n"
	self.footer = self.footer.."		fill(120, 120, 120, 180);\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	translate(0,0,-50);\n"
	self.footer = self.footer.."	box(200,200,100);\n"
	self.footer = self.footer.."	translate(0,0,50);\n"
	self.footer = self.footer.."}\n"
	self.footer = self.footer.."void mouseDragged() {\n"
	self.footer = self.footer.."	middlex += mouseX - pmouseX;\n"
	self.footer = self.footer.."	middley += mouseY - pmouseY;\n"
	self.footer = self.footer.."}\n"
	self.footer = self.footer.."void keyPressed() {\n"
	self.footer = self.footer.."	if (keyCode == UP) {\n"
	self.footer = self.footer.."		middlez += 15.0;\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	if (keyCode == DOWN) {\n"
	self.footer = self.footer.."		middlez -= 15.0;\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	if (key == 'r' || key == 'R') {\n"
	self.footer = self.footer.."		if (isRotating) {\n"
	self.footer = self.footer.."			isRotating = false;\n"
	self.footer = self.footer.."		} else {\n"
	self.footer = self.footer.."			isRotating = true;\n"
	self.footer = self.footer.."			if (!isRotatingX && !isRotatingY && !isRotatingZ) { isRotatingZ = true; }\n"
	self.footer = self.footer.."		}\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	if (key == 'c' || key == 'C') {\n"
	self.footer = self.footer.."		if (alternateColors) {\n"
	self.footer = self.footer.."			alternateColors = false;\n"
	self.footer = self.footer.."		} else {\n"
	self.footer = self.footer.."			alternateColors = true;\n"
	self.footer = self.footer.."		}\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	if (key == 'x' || key == 'X') {\n"
	self.footer = self.footer.."		if (isRotatingX) {\n"
	self.footer = self.footer.."			isRotatingX = false;\n"
	self.footer = self.footer.."		} else {\n"
	self.footer = self.footer.."			isRotatingX = true;\n"
	self.footer = self.footer.."		}\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	if (key == 'y' || key == 'Y') {\n"
	self.footer = self.footer.."		if (isRotatingY) {\n"
	self.footer = self.footer.."			isRotatingY = false;\n"
	self.footer = self.footer.."		} else {\n"
	self.footer = self.footer.."			isRotatingY = true;\n"
	self.footer = self.footer.."		}\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."	if (key == 'z' || key == 'Z') {\n"
	self.footer = self.footer.."		if (isRotatingZ) {\n"
	self.footer = self.footer.."			isRotatingZ = false;\n"
	self.footer = self.footer.."		} else {\n"
	self.footer = self.footer.."			isRotatingZ = true;\n"
	self.footer = self.footer.."		}\n"
	self.footer = self.footer.."	}\n"
	self.footer = self.footer.."}\n"
	
	return self.footer
end

return Pde