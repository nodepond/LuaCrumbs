-----------------------------------------------------------------------------
-- LuaCrumbs - GCode coreFormat-implementation
-- http://luacrumbs.nodepond.com / http://www.luacrumbs.org
--
-- License: MIT/X
--
-- (c) 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
--
-- First version 24. November 2012
-----------------------------------------------------------------------------

-- simple class constructor
GCode = {}
GCode.__index = GCode

function GCode.new()
   local gcode = {}
   setmetatable(gcode,GCode)
   return gcode
end

function GCode:init(_projectname)
	self.projectname = _projectname
end

function GCode:inspect()
	print("GCode: NOT IMPLEMENTED YET!")
end

function GCode:moveTo(_x, _y, _z, _pre_x, _pre_y, _pre_z)
	-- TODO
end

function GCode:setSpeed(_speed)
	-- TODO
end

function GCode:pause(_seconds)
	-- TODO
end

function GCode:pencilUp(_isPencilUpAlreadyUp, _x, _y, _cur_z, _dest_z)
	-- TODO
end

function GCode:pencilDown(_isPencilUpAlreadyDown, _x, _y, _cur_z, _dest_z)
	-- TODO
end

function GCode:close()

	print("\nStarting to write GCode-file.")
	local output_file = self.projectname..".ngc"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)

	file:write(self:getHeader())
	file:write(self:getBody())
	file:write(self:getFooter())

	print("Writing of "..output_file.." complete.\n")
end


function GCode:getHeader()
	self.header = "G40 (disable tool radius compensation)\n"
	self.header = self.header.."G49 (disable_tool_length_compensation)\n"
	self.header = self.header.."G80 (cancel_modal_motion)\n"
	self.header = self.header.."G54 (select_coordinate_system_1)\n"
	self.header = self.header.."G90 (Absolute distance mode)\n" -- "incremental motion"
	self.header = self.header.."G21 (metric)\n"
	self.header = self.header.."G61 (exact path mode)\n"

	return self.header
end
function GCode:getBody()
	self.body = "\n"
	return self.body
end
function GCode:getFooter()
	self.footer = ""
	return self.footer
end

return GCode
