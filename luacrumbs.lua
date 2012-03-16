-----------------------------------------------------------------------------
-- LuaCrumbs.lua
-- Scripting-libary for generating G-Code for CNC-machines.
-- Jump straight into the fun!
-- http://luacrumbs.nodepond.com
--
-- License: MIT/X
-- 
-- (c) 2011 Nodepond / Martin Wisniowski (hello@nodepond.com)
--
-----------------------------------------------------------------------------


module(..., package.seeall)

-- Core (Really most basic functions)

-- define some variables for config and control
crumbs_circlemode = 0 -- crumbs_circlemode: 0 = corner & HPGL, 1 = radius

crumbs_projectname = ""

crumbs_generate_gcode = true -- generate html output file?
crumbs_gcode = "" -- the content, that is added to the html-file

crumbs_generate_html = true -- generate html output file?
crumbs_html = "" -- the content, that is added to the html-file

crumbs_generate_svg = false -- generate svg output file?
crumbs_svg = "" -- the content, that is added to the svg-file

crumbs_generate_hpgl = false -- generate hpgl output file?
crumbs_hpgl = "" -- the content, that is added to the hpgl-content

local hpgl_scale = 10 -- currently experimental feature. add a scale to HPGL-coordinates. There is also a way to modify the initial-plotspace and scale with IN and SC-command. Maybe this will fir the need better. But let's evaluate later! 

-- keep track of the current positions (we need this in some occations)
local curx = 0
local cury = 0
local curz = 0

-- keep track of the x- and y maximum (needed .i.e. html-cavas-size)
local outerx = 0
local outery = 0

-- store a rotation-value for cases, i.e. if multiple rotations are added
local rotation = 0

-- additional canvas / html5 parameters
local html_zoom = 1
local html_linewidth = 1

function standardInit(verbose)
	-- this is the standard init
		
	if crumbs_generate_gcode then
		crumbs_gcode = ""
	
		if verbose then
			crumbs_gcode = crumbs_gcode.."G40 (disable tool radius compensation)\n"
			crumbs_gcode = crumbs_gcode.."G49 (disable_tool_length_compensation)\n"
			crumbs_gcode = crumbs_gcode.."G80 (cancel_modal_motion)\n"
			crumbs_gcode = crumbs_gcode.."G54 (select_coordinate_system_1)\n"
			crumbs_gcode = crumbs_gcode.."G90 (Absolute distance mode)\n" -- "incremental motion"
			crumbs_gcode = crumbs_gcode.."G21 (metric)\n"
			crumbs_gcode = crumbs_gcode.."G61 (exact path mode)\n"
		else -- comment: is there any real reason for shortening and therefore obfuscinating the g-code?!
			crumbs_gcode = crumbs_gcode.."G40\n"
			crumbs_gcode = crumbs_gcode.."G49\n"
			crumbs_gcode = crumbs_gcode.."G80\n"
			crumbs_gcode = crumbs_gcode.."G54\n"
			crumbs_gcode = crumbs_gcode.."G90\n"
			crumbs_gcode = crumbs_gcode.."G21\n"
			crumbs_gcode = crumbs_gcode.."G61\n"
		end
	end
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = "IN;PA;SP1;PU0,0;"
	end
end

function setSpeed(val)
	if val == nil or val == 0 then
		crumbs_gcode = crumbs_gcode.."G0\n"
		return
	end
	if val > 0 then
		crumbs_gcode = crumbs_gcode.."F"..val.."\n"
	end
end

-- Move to absolute coordinate (every parameter is optional. If nil, the xyz value is unchanged)
-- TODO: Please test this with only one or zero parameters with an g-code device
function moveTo(xpos, ypos, zpos)
	crumbs_gcode = crumbs_gcode.."G1"
	if xpos ~= nil then crumbs_gcode = crumbs_gcode.." x"..xpos end
	if ypos ~= nil then crumbs_gcode = crumbs_gcode.." y"..ypos end
	if zpos ~= nil then crumbs_gcode = crumbs_gcode.." z"..zpos end
	crumbs_gcode = crumbs_gcode.."\n"
	
	-- update the current position
	if xpos ~= nil then curx = xpos end
	if ypos ~= nil then cury = ypos end
	if zpos ~= nil then curz = zpos end
	
	if curx > outerx then
		outerx = curx
	end
	if cury > outery then
		outery = cury
	end
	
	if crumbs_generate_html and zpos == nil and xpos ~= nil and ypos ~= nil then
		-- we currently only support "2d-drawing"
		crumbs_html = crumbs_html.."context.moveTo(".. xpos*html_zoom ..", ".. ypos*html_zoom ..");\n"
		--crumbs_html = crumbs_html.."context.stroke();\n"
	end
	
	if crumbs_generate_hpgl and zpos == nil and xpos ~= nil and ypos ~= nil then
		if isPencilDown then
			crumbs_hpgl = crumbs_hpgl.."PU"..(-xpos*hpgl_scale)..","..(ypos*hpgl_scale)..";"
		else
			crumbs_hpgl = crumbs_hpgl.."PD"..(-xpos*hpgl_scale)..","..(ypos*hpgl_scale)..";"
		end		
	end
	
end

-- Draw circle, counterclockwise-parameter is optional
function circle(radius, counterclockwise)
	if counterclockwise == true then
		crumbs_gcode = crumbs_gcode.."G3 J"..radius.."\n"
	else
		crumbs_gcode = crumbs_gcode.."G2 J"..radius.."\n"
	end
	
	if crumbs_generate_html then
		crumbs_html = crumbs_html.."context.beginPath();\n"
		crumbs_html = crumbs_html.."context.arc("..(curx)*html_zoom..", "..(cury+radius)*html_zoom..", "..(radius)*html_zoom..", 0, Math.PI * 2, false);\n"
		crumbs_html = crumbs_html.."context.closePath();\n"
		if counterclockwise then 
			crumbs_html = crumbs_html.."context.strokeStyle = \"#999\";\n"
			crumbs_html = crumbs_html.."context.lineWidth = 4;\n" -- visually show, that this is a counterclockwise circle
		else
			crumbs_html = crumbs_html.."context.strokeStyle = \"#666\";\n"
			crumbs_html = crumbs_html.."context.lineWidth = 2;\n"
		end
		crumbs_html = crumbs_html.."context.stroke();\n"
		crumbs_html = crumbs_html.."context.strokeStyle = \"#666\";\n" -- in any case, back to default
		crumbs_html = crumbs_html.."context.lineWidth = 2;\n"		
	end
	
	if crumbs_generate_svg then
		crumbs_svg = crumbs_svg.."<circle cx=\""..curx.."\" cy=\""..(cury+(radius)).."\" r=\""..radius.."\" stroke=\"black\" fill=\"rgb(255,255,255)\" fill-opacity=\"0.0\" stroke-width=\"1px\"/>\n"
	end
	
	if crumbs_generate_svg then
		crumbs_svg = crumbs_svg.."<circle cx=\""..curx.."\" cy=\""..(cury+(radius)).."\" r=\""..radius.."\" stroke=\"black\" fill=\"rgb(255,255,255)\" fill-opacity=\"0.0\" stroke-width=\"1px\"/>\n"
	end
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."CI"..(radius*hpgl_scale)..";"
	end
	
end

function pause(seconds)
	if seconds == nil then
		seconds = 0
	else
		if seconds < 0 then
			print("Error at function pause(seconds): Seconds must be nil or a positive number.")
			return
		end
	end
	crumbs_gcode = crumbs_gcode.."G4 P"..seconds.."\n"
end
-- verbose = true or false
function init(projectname, verbose)
	if projectname == nil then projectname = "particles-project" end
	crumbs_projectname = projectname
	
	crumbs_circlemode = 1 -- set circlemode to radius, not corner
	
	standardInit(verbose)
	setSpeed(1200)
	
	outerx = 0
	outery = 0
end

-- universal function to write something into the gcode file, i.e. custom commands like "M101"
function insertIntoGCodeFile(string)
	crumbs_gcode = crumbs_gcode..string.."\n"
end

--- Generates a html-5 preview file.
-- The generated file can be opened in any html5-canvas ready browser, to preview the output if the g-code.
-- @params flag: true or false
-- @params zoom_factor: (optional) scale the output with this zoom-factor. Default: 1
function generateHTML(flag, zoom_factor, line_width)
	crumbs_generate_html = flag
	if (zoom_factor ~= nil) then
		html_zoom = zoom_factor	
	end
	if (line_width ~= nil) then
		html_linewidth = line_width	
	end
end

function doGenerateHTML()
	print("\nStarting to write html-file.")
	output_file = crumbs_projectname..".html"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
		
	file:write("<html>\n")
	file:write("<head>\n")
	file:write("<title>"..output_file.." - Made with Particles G-Code Generator</title>\n")
	file:write("</head>\n")
	file:write("<body>\n")
	file:write("<canvas id=\"c\" width=\""..(outerx+html_linewidth+1)*html_zoom.."\" height=\""..(outery+html_linewidth+1)*html_zoom.."\"></canvas>\n")
	file:write("<script>\n")
	file:write("var c = document.getElementById(\"c\");\n")
	file:write("var context = c.getContext(\"2d\");\n")
	file:write("context.strokeStyle = \"#666\";\n")
	file:write("context.lineWidth = "..html_linewidth..";\n")		
	file:write(crumbs_html)
	file:write("</script>\n")
	file:write("</body>\n")
	file:write("</html>\n")
	print("Writing of "..output_file.." complete.\n")	
end

--- Should Particles generate a ngc-file (G-Code). The default is yes, since it is intended to use Particles with G-Code!
-- @params flag: true or false
function generateGCode(flag)
	crumbs_generate_gcode = flag
end

function doGenerateGCode()
	print("\nStarting to write GCode-file.")
	output_file = crumbs_projectname..".ngc"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)			
	file:write(crumbs_gcode)
	file:close()
	print("Writing of "..output_file.." complete.\n")	
end

--- Should Particles generate a svg-file. The default is no.
-- @params flag: true or false
function generateSVG(flag)
	crumbs_generate_svg = flag
end

function doGenerateSVG()
	print("\nStarting to write SVG-file.")
	output_file = crumbs_projectname..".svg"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)
	--<svg width="100%" height="100%">
	-- <g transform="translate(50,50)">
	--    <rect x="0" y="0" width="150" height="50" style="fill:red;" />
	--  </g>
	--</svg>
	file:write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
	file:write("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 20001102//EN\" \"http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd\">\n")
	file:write("<svg width=\"100%\" height=\"100%\">\n")
	file:write("<g transform=\"translate(0,0)\">\n")
	file:write(crumbs_svg)	
	file:write("</g>\n")
	file:write("</svg>")
	file:close()
	print("Writing of "..output_file.." complete.\n")	
end

--- Should Particles generate a hpgl-file (HPGL). The default is no.
-- @params flag: true or false
function generateHPGL(flag)
	crumbs_generate_hpgl = flag
end

function doGenerateHPGL()
	print("\nStarting to write HPGL-file.")
	output_file = crumbs_projectname..".hpgl"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	crumbs_hpgl = crumbs_hpgl .. "E;"		
	file:write(crumbs_hpgl)
	file:close()
	print("Writing of "..output_file.." complete.\n")	
end

function close()	
	if crumbs_generate_gcode then		
		crumbs_gcode = crumbs_gcode.."M2\n" -- is this call maybe in the wrong place?
		doGenerateGCode()
	end
		
	if crumbs_generate_html then
		doGenerateHTML()
	end
	
	if crumbs_generate_svg then
		doGenerateSVG()
	end
	
	if crumbs_generate_hpgl then
		doGenerateHPGL()
	end
end
-- Core (Really most basic functions) END

crumbs_penciluppos = 30
crumbs_pencildownpos = 0

-- Drawing Core (first layer upon core: simple "2D/3D" drawing functions)
function setPencilUpPosition(zpos)
	crumbs_penciluppos = zpos
end

function setPencilDownPosition(zpos)
	crumbs_pencildownpos = zpos
end

function getPencilUpPosition()
	return crumbs_penciluppos
end

function getPencilDownPosition()
	return crumbs_pencildownpos
end

function moveToZPosition(zpos)
	moveTo(nil, nil, zpos)
end

function pencilUp()
	moveToZPosition(crumbs_penciluppos)
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."PU;"
	end
end

function pencilDown()
	moveToZPosition(crumbs_pencildownpos)
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."PD;"
	end
end

function isPencilDown()
	return curz == crumbs_pencildownpos
end

-- NOTICE: line and lineTo are still problematic, because tey take move-to into account, but are not always "drawn". 
-- This is a little ugly dependency, also that there is an 'if crumbs_generate_html then'-statement at this place. 
-- This kind of statements should be only in the Core!!

--- Draws a line from start position to end position. 
-- Before drawing to head is always moved up to up-position (z-axis).
-- When drawing stats, the head is put down to down-position, then the line s drawn.
-- If pencil is not down, it will go down.
-- @param xstart x-start-position in absolute coordinates
-- @param ystart y-start-position in absolute coordinates
-- @param xpos x-destination in absolute coordinates
-- @param ypos y-destination in absolute coordinates
function line(xstart, ystart, xdest, ydest)
	pencilUp()
	moveTo(xstart, ystart)
	pencilDown()
	moveTo(xdest, ydest)	
	
	if crumbs_generate_html then
		-- we currently only support "2d-drawing"
		crumbs_html = crumbs_html.."context.moveTo(".. xstart*html_zoom ..", ".. ystart*html_zoom ..");\n"
		crumbs_html = crumbs_html.."context.lineTo(".. xdest*html_zoom ..", ".. ydest*html_zoom ..");\n"
		crumbs_html = crumbs_html.."context.stroke();\n"
	end
	
	if crumbs_generate_svg then
		-- we currently only support "2d-drawing"
		crumbs_svg = crumbs_svg.."<line x1=\""..xstart.."\" y1=\""..ystart.."\" x2=\""..xdest.."\" y2=\""..ydest.."\" stroke=\"black\" stroke-width=\"1px\"/>\n"
	end
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."PU"..(-xstart*hpgl_scale)..","..(ystart*hpgl_scale)..";"
		crumbs_hpgl = crumbs_hpgl.."PD"..(-xdest*hpgl_scale)..","..(ydest*hpgl_scale)..";"
	end
end

--- Draw a line straight from recent position. 
-- If pencil is not down, it will go down.
-- @param xpos x-destination in absolute coordinates
-- @param ypos y-destination in absolute coordinates
function lineTo(xpos, ypos)
	-- important: generate html first, otherwise "moveTo" will set "head" to current position. 
	-- result will be a context.lineTo with zero pixel length
	if crumbs_generate_html then
		-- we currently only support "2d-drawing"
		crumbs_html = crumbs_html.."context.lineTo(".. xpos*html_zoom ..", ".. ypos*html_zoom ..");\n"
		crumbs_html = crumbs_html.."context.stroke();\n"
	end
	
	if crumbs_generate_svg then
		-- we currently only support "2d-drawing"
		crumbs_svg = crumbs_svg.."<line x1=\""..curx.."\" y1=\""..cury.."\" x2=\""..xpos.."\" y2=\""..ypos.."\" stroke=\"black\" stroke-width=\"1px\"/>\n"
	end
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."PD"..(-xpos*hpgl_scale)..","..(ypos*hpgl_scale)..";"
	end
	
	pencilDown() -- if down, nothing should happen
	moveTo(xpos, ypos)
end

-- counterclockwise is optional
function circleAt(xpos, ypos, radius, counterclockwise)	
	-- HPGL-handling
	if crumbs_generate_hpgl then
		moveTo(xpos, ypos)
		circle(radius, counterclockwise)
	else
	-- the other stuff (this could be a first sign of making a better architecture in the future, with serial-redering of files, not "parallel" file-processing)
	  pencilUp()
	  if crumbs_circlemode == 0 or generate_hpgl then
	  	moveTo(xpos, ypos) 
	  elseif crumbs_circlemode == 1 then
		moveTo(xpos, ypos-(radius))
	  end
	  pencilDown()
	  circle(radius, counterclockwise)	
	end
end


-- Turtle Core (applying "LOGO-like" drawing, with rotating the "cursor" and "moving forwards and backwards")

--- Add a rotation to the current rotation-position 
-- @param degrees Degrees to add. Value can be negative as well.
function addRotation(degrees)
	rotation = rotation + degrees
end

--- Sets the rotation directly to the specified value 
-- @param degrees Degrees to set. Value should be between -360 and 360.
function setRotation(degrees)
	rotation = degrees
end

--- Get the rotation parameter 
-- Retruns the recent rotation-value
function getRotation()
	return rotation
end

--- Moves the "cursor" forward with the current-rotation angle be the specified value  
-- @param steps Length of the step to move forward
function moveForward(steps)
	-- this seems to be much easier: http://stackoverflow.com/questions/1055062/how-to-calculate-a-point-on-a-rotated-axis
	
	-- subtract -90 degrees, in order to have the 0-rotation angle "point to up" 
	local newposx = math.cos(math.rad(rotation-90)) * steps
	local newposy = math.sin(math.rad(rotation-90)) * steps
	
	--print("curx "..curx.." cury "..cury)
	--print("newposx "..newposx.." newposy "..newposy)
	
	-- check if pencil is down and decide the drawing-code
	if isPencilDown() then
		lineTo(curx + newposx, cury + newposy)
	else
		moveTo(curx + newposx, cury + newposy)
	end
end

--- Same as moveForward, but in the other direction
-- @param steps Length of the step to move backwards
function moveBackward(steps)
	
end


--- RepRap-related commands
-- Doc: http://reprap.org/wiki/Mendel_User_Manual:_RepRapGCodes
function setTemparatur()
end

function homeAllAxes()
end

-- HPGL-Commands

--- HPGL Set Pen Number
-- @params number. Default is 1
function setHPGLPen(number)
	if (number == nil) then
		number = 1
	end
	if crumbs_generate_hpgl then
		crumbs_hpgl = "SP"..number..";"
	end
end

--- HPGL Set Scalefactor
-- @params scale. Set a custom scale-factor. Default is 10. This feature is currently exerimental.
function setHPGLScale(scale)
	if (scale == nil) then
		scale = 10
	end
	hpgl_scale = scale
end


