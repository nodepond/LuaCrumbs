-----------------------------------------------------------------------------
-- LuaCrumbs - Html3D template for loading ide core implementation
-- http://luacrumbs.nodepond.com / http://www.luacrumbs.org
--
-- License: MIT/X
-- 
-- (c) 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
--
-- Work started on this file on 11. June 2012 / THIS IS EXPERIMENTAL WORK ATM
-- First version 17. November 2012
-----------------------------------------------------------------------------

-- simple class constructor
Html3D = {}
Html3D.__index = Html3D

function Html3D.new()
   local html3d = {}         
   setmetatable(html3d,Html3D)
   return html3d
end

function Html3D:init(_projectname)
	self.projectname = _projectname
end

function Html3D:inspect()
	print("Html3D: nothing to inspect")
end

function Html3D:moveTo(_x, _y, _z, _pre_x, _pre_y, _pre_z)
	-- nothing to do
end

function Html3D:setSpeed(_speed)
	-- nothing to do
end

function Html3D:pause(_seconds)
	-- nothing to do
end

function Html3D:pencilUp(_isPencilUpAlreadyUp, _x, _y, _cur_z, _dest_z)
	-- nothing to do
end

function Html3D:pencilDown(_isPencilUpAlreadyDown, _x, _y, _cur_z, _dest_z)
	-- nothing to do
end

function Html3D:close()

	print("\nStarting to write html 3d-file.")
	local output_file = self.projectname.."-3d.html"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	
	file:write(self:getHeader())
	file:write(self:getBody())
	file:write(self:getFooter())
	
	print("Writing of "..output_file.." complete.\n")
end


function Html3D:getHeader()
	self.header = "<html>\n"
	self.header = self.header.."<head>\n"
	self.header = self.header.."<title>"..self.projectname.." - Made with LuaCrumbs - luacrumbs.org</title>\n"
	self.header = self.header.."<style>body { font-family: helvetica, arial, sans-serif;\nfont-size: 11px;\nline-height: 18px; } a, a:hover, a:link, a:active { color:#339933; }</style>\n"
	self.header = self.header.."</head>\n"
	self.header = self.header.."<body>\n"
	self.header = self.header.."<script src=\"../../3rdparty/processing-1.3.6.min.js\"></script>\n"
	self.header = self.header.."<div><canvas data-processing-sources=\""..self.projectname..".pde\"></canvas></div>\n"
	self.header = self.header.."<div>move mouse to rotate, drag mouse to move focus point<br />\n"
	self.header = self.header.."<br />\n"
	self.header = self.header.."r - toggle automatic rotation<br />\n"
	self.header = self.header.."x, y, z - toggle autorotate x, y, z-axis<br />\n"
	self.header = self.header.."c - alternate colorscheme<br />\n"
	self.header = self.header.."<br />\n"
	self.header = self.header.."generated with <a href=\"http://www.luacrumbs.org/\">LuaCrumbs</a> a project from <a href=\"http://www.nodepond.com\">Nodepond</a><br />\n"
	self.header = self.header.."</div>\n"
	
	return self.header
end
function Html3D:getBody()
	self.body = "\n"
	return self.body
end
function Html3D:getFooter()
	self.footer = ""
	self.footer = self.footer.."</body>\n"
	self.footer = self.footer.."</html>\n"	
	return self.footer
end

return Html3D