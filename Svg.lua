-----------------------------------------------------------------------------
-- LuaCrumbs - Svg-format core implementation
-- http://luacrumbs.nodepond.com / http://www.luacrumbs.org
--
-- License: MIT/X
-- 
-- (c) 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
--
-- First version 18. November 2012
-----------------------------------------------------------------------------

-- simple class constructor
Svg = {}
Svg.__index = Svg

function Svg.new()
   local svg = {}         
   setmetatable(svg,Svg)
   return svg
end

function Svg:init(_projectname)
	self.projectname = _projectname
end

function Svg:inspect()
	print("Svg: nothing to inspect")
end

function Svg:moveTo(_x, _y, _z, _pre_x, _pre_y, _pre_z)
	-- nothing to do
end

function Svg:setSpeed(_speed)
	-- nothing to do
end

function Svg:pause(_seconds)
	-- nothing to do
end

function Svg:pencilUp(_isPencilUpAlreadyUp, _x, _y, _cur_z, _dest_z)
	-- nothing to do
end

function Svg:pencilDown(_isPencilUpAlreadyDown, _x, _y, _cur_z, _dest_z)
	-- nothing to do
end

function Svg:close()

	print("\nStarting to write Svg-file.")
	local output_file = self.projectname..".svg"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	
	file:write(self:getHeader())
	file:write(self:getBody())
	file:write(self:getFooter())
	
	print("Writing of "..output_file.." complete.\n")
end


function Svg:getHeader()
	self.header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
	self.header = self.header.."<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 20001102//EN\" \"http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd\">\n"
	self.header = self.header.."<svg width=\"100%\" height=\"100%\">\n"
	self.header = self.header.."<g transform=\"translate(0,0)\">\n"

	return self.header
end
function Svg:getBody()
	self.body = "\n"
	return self.body
end
function Svg:getFooter()
	self.footer = "</g>\n"
	self.footer = self.footer.."</svg>"
	return self.footer
end

return Svg