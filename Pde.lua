-----------------------------------------------------------------------------
-- LuaCrumbs - pde (Processing) core implementation
-- http://luacrumbs.nodepond.com
--
-- License: MIT/X
-- 
-- (c) 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
--
-- Work started on this file on 11. June 2012 / THIS IS EXPERIMENTAL WORK ATM
--
-----------------------------------------------------------------------------

-- simple class constructor
Pde = {}
Pde.__index = Pde

function Pde.new(projectname)
   local pde = {}         
   setmetatable(pde,Pde)  				-- make Pde handle lookup
   pde.projectname = projectname      	-- initialize object
   return pde
end

-- implement the core-methods at this place. Mandatory are moveTo(xpos, ypos, zpos), 
-- function circle(radius, counterclockwise), function pause(seconds) (?), close(), 
-- returnHeader(), returnFooter(), returnBody() ... 
-- in addition: what about "line, lineTo, pencilUp, pencilDown, circleAt"
function Pde:doDraw(test)
   print("do draw test successful with project: "..self.projectname)
end

function Pde:moveTo(xpos, ypos, zpos)
end

-- function like this in classes?
-- (desired destination and current position is transmitted from luaCrumbs position locate system,
-- every generated code needs a slighly diffrent handling of this situation. i.e. moveZ is totally diffrent in g-code than SVG,
-- also is nil-handling)
-- Pde:handleCurrentPositionWith(xpos, curx, ypos, cury, zpos, curz)
-- end
