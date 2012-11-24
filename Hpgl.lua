-----------------------------------------------------------------------------
-- LuaCrumbs - Hpgl coreFormat-implementation
-- http://luacrumbs.nodepond.com / http://www.luacrumbs.org
--
-- License: MIT/X
-- 
-- (c) 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
--
-- First version 24. November 2012
-----------------------------------------------------------------------------

-- simple class constructor
Hpgl = {}
Hpgl.__index = Hpgl

function Hpgl.new()
   local hpgl = {}         
   setmetatable(hpgl,Hpgl)
   return hpgl
end

function Hpgl:init(_projectname)
	self.projectname = _projectname
end

function Hpgl:inspect()
	print("Hpgl: nothing to inspect")
end

function Hpgl:moveTo(_x, _y, _z, _pre_x, _pre_y, _pre_z)
	-- nothing to do
end

function Hpgl:setSpeed(_speed)
	-- nothing to do
end

function Hpgl:pause(_seconds)
	-- nothing to do
end

function Hpgl:pencilUp(_isPencilUpAlreadyUp, _x, _y, _cur_z, _dest_z)
	-- nothing to do
end

function Hpgl:pencilDown(_isPencilUpAlreadyDown, _x, _y, _cur_z, _dest_z)
	-- nothing to do
end

function Hpgl:close()

	print("\nStarting to write Hpgl-file.")
	local output_file = self.projectname..".hpgl"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	
	file:write(self:getHeader())
	file:write(self:getBody())
	file:write(self:getFooter())
	
	print("Writing of "..output_file.." complete.\n")
end


function Hpgl:getHeader()
	self.header = "IN;PA;SP1;PU0,0;VS5,1;"
	return self.header
end
function Hpgl:getBody()
	self.body = "\n"
	return self.body
end
function Hpgl:getFooter()
	self.footer = "E;"
	return self.footer
end

return Hpgl