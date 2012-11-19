-----------------------------------------------------------------------------
-- LuaCrumbs.lua
-- Scripting-libary for generating Code for FabLabs.
--
-- http://luacrumbs.nodepond.com / http://www.luacrumbs.org
--
-- License: MIT/X, http://opensource.org/licenses/MIT
-- 
-- (c) 2011 / 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
-- Permission is hereby granted, free of charge, to any person obtaining a copy 
-- of this software and associated documentation files (the "Software"), to deal 
-- in the Software without restriction, including without limitation the rights 
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
-- copies of the Software, and to permit persons to whom the Software is 
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included 
-- in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
-- THE SOFTWARE.
-----------------------------------------------------------------------------

-- Notice on scales: We assume 100 scales to be 10cm (100 millieters) in reality.
-- This is, that 1 scale is 1mm. With 100 scales equals 10cm you can work in a 
-- "normalized" style, means: make your work in 100 scale-steps and in the and
-- multiply it with a scale-multipliyer, i.e. scale*10 to haver the meter-domain.
-- I.e. scale*25 then would scale 10cm to 2,5 meters. 

module(..., package.seeall)

local outputFormatTable = {}

-- keep an overview!
local cur_x = 0
local cur_y = 0
local cur_z = 0
local pencil_up_pos = 30
local pencil_down_pos = 0
local cur_rotation = 0

-- keep track of the x- and y maximum (needed .i.e. html-cavas-size)
-- TODO: Bounds maybe later
--local outerx = 0
--local outery = 0

--- Adds a format from CoreFormatClasses to the output files
-- TODO: EXPLAIN THIS BETTER!
-- @params _formatObject An object, derived from a class, that defines the output foo for each of the LuaCrums-core files 
function addFormat(_formatObject)
	table.insert(outputFormatTable, _formatObject)
end

--- Inits the project with the projectname
-- You init the all project-files with this custom projectname. This name will be used, to generate the different files, like .svg, .html, .ngc, specified by OutputFormatClasses
-- @params projectname Name of the project, i.e. "myProject" 
function init(_projectname)
	if _projectname == nil then _projectname = "cologne_at_night" end

	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:init(_projectname)
	end
end

--- Close the project. This command is mandatory!
-- Call this function at the end of your lua-script. It is a must, because ending-tags and diffrerent other parameters are written here.
-- Without this closing statement, you will not get corrently generated files! (In fact, that are not generated at all)
function close()	
	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:close()
	end
end

--- Move to absolute coordinate X and Y
-- @params _xpos Move to absolute x-position.
-- @params _ypos Move to absolute y-position.
function moveTo(_xpos, _ypos)
	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:moveTo(_xpos, _ypos, cur_z, cur_x, cur_y, cur_z)
	end

	cur_x = _xpos
	cur_y = _ypos
end

--- Setter of the pencil up position
-- Sets the pencil up position
-- Pencil up-position can't be smaller than pencil up. If pencil_up_pos < pencil_up_pos then pencil_up_pos = pencil_down_pos
-- @params zpos (number) pencil up position
function setPencilUpPosition(_zpos)
	pencil_up_pos = _zpos
	-- avoid, that pencilUp is below the pencilDown position
	if pencil_up_pos < pencil_down_pos then
		pencil_up_pos = pencil_down_pos
	end
end

--- Setter of the pencil down position
-- Sets the pencil down position. 
-- Pencil down-position can't be greater than pencil up. If pencil_down_pos > pencil_up_pos then pencil_down_pos = pencil_up_pos
-- @params zpos (number) pencil down position
function setPencilDownPosition(_zpos)
	pencil_down_pos = _zpos
	-- avoid, that pencilDown is above the pencilUp position
	if pencil_down_pos > pencil_up_pos then
		pencil_down_pos = pencil_up_pos
	end
end

--- Getter of the pencil up position
-- Gets the current pencil up position, returns a number
function getPencilUpPosition()
	return pencil_up_pos
end
--- Getter of the pencil up position
-- Gets the current pencil up position, returns a number
function getPencilDownPosition()
	return pencil_down_pos
end

--- Checks, if pencil is currently at drawing (z) position  
-- Returns true, if the pencil is currently at the drawing-position, aka pencildown-position, otherwise false.
function isPencilDown()
	return cur_z == pencil_down_pos
end

function isPencilUp()
	return cur_z == pencil_up_pos
end

--- Moves the pencil to pencilup-position (z-axis)  
-- Move the head up and down with pencilUp() and pencilDown()
-- If the head is at the current pencilUp position, this command will normally do nothing.
function pencilUp()
	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:pencilUp(isPencilUp(), cur_x, cur_y, cur_z, pencil_up_pos)
	end

	cur_z = pencil_up_pos
end

--- Moves the pencil to pencildown-position (z-axis)  
-- Move the head up and down with pencilUp() and pencilDown()
-- If the head is at the current pencilDown position, this command will normally do nothing.
function pencilDown()
	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:pencilDown(isPencilDown(), cur_x, cur_y, cur_z, pencil_down_pos)
	end

	cur_z = pencil_down_pos
end

--- Draws a line from start X/Y-position to X/Y-destination position. 
-- Before starting to draw, the drawing-head is always moved up to up-position (z-axis), aka pencilUp.
-- When drawing starts, the head is put down to down-position aka pencilDown. If pencil is not down, it will go down.
-- @param xstart X-start-position in absolute coordinates
-- @param ystart Y-start-position in absolute coordinates
-- @param xdest X-destination in absolute coordinates
-- @param ydest Y-destination in absolute coordinates
function line(_xstart, _ystart, _xdest, _ydest)
	pencilUp()
	moveTo(_xstart, _ystart)
	pencilDown()
	moveTo(_xdest, _ydest)
end

--- Draw a line straight from recent position to X/Y-destination.
-- If pencil is not down, it will go down.
-- @param xpos X-Position of destination in absolute coordinates
-- @param ypos Y-Position of destination in absolute coordinates
function lineTo(xpos, ypos)
	pencilDown()
	moveTo(_xpos, _ypos)	
end

--- Pause the drawing in seconds
-- @params seconds (number) seconds to pause. Parameter must be a positive number.
function pause(_seconds)
	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:pause(_seconds)
	end
end

--- Pause the drawing in seconds
-- @params seconds (number) seconds to pause. Parameter must be a positive number.
function setSpeed(_speed)
	for key,outputFormat in pairs(outputFormatTable) do
		outputFormat:setSpeed(_speed)
	end
end

--- Add a rotation to the current rotation-position 
-- @param degrees Degrees to add to th current rotation. Value can be positive and negative as well.
function addRotation(_degrees)
	cur_rotation = cur_rotation + _degrees
end

--- Sets the rotation directly to the specified value 
-- @param _degrees Degrees to set. Value should be between -360 and 360.
function setRotation(_degrees)
	cur_rotation = _degrees
end

--- Get the rotation parameter 
-- Returns the recent rotation-value
function getRotation()
	return cur_rotation
end

--- Getter of x
-- Returns the current x-value
function getX()
	return cur_x
end

--- Getter of y
-- Returns the current y-value
function getY()
	return cur_y
end

--- Getter of z
-- Returns the current z-value
function getZ()
	return cur_z
end

--- Moves the "cursor" forward with the current-rotation angle be the specified value  
-- @param _steps Length of the step to move forward
function moveForward(_steps)
	-- this seems to be much easier: http://stackoverflow.com/questions/1055062/how-to-calculate-a-point-on-a-rotated-axis
	
	-- subtract -90 degrees, in order to have the 0-rotation angle "point to up" 
	local newposx = math.cos(math.rad(cur_rotation-90)) * _steps
	local newposy = math.sin(math.rad(cur_rotation-90)) * _steps

	moveTo(cur_x + newposx, cur_y + newposy)
end

--- Same as moveForward, but in the other direction
-- @param _steps Length of the step to move backwards
function moveBackward(_steps)
		-- subtract -90 degrees, in order to have the 0-rotation angle "point to up" 
	local newposx = math.cos(math.rad(cur_rotation-90)) * _steps
	local newposy = math.sin(math.rad(cur_rotation-90)) * _steps

	moveTo(cur_x - newposx, cur_y - newposy)
end
