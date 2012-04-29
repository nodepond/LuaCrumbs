-----------------------------------------------------------------------------
-- LuaCrumbs.lua
-- Scripting-libary for generating Code for FabLabs.
-- Jump straight into the fun!
-- http://luacrumbs.nodepond.com
--
-- License: MIT/X
-- 
-- (c) 2011 / 2012 Nodepond.com / Martin Wisniowski (hello@nodepond.com)
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

crumbs_generate_html3d = true -- generate a html-3d output file (uses webGL)?
crumbs_html3d = "" -- the content, that is added to the html-3d-file
crumbs_pde3d = "" -- storing the processing-file, that gets loaded into processingjs-facility 

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

--- Inits the project with the projectname
-- You init the project with a custom projectname. This name will be used, to generate the different files, like .svg, .html, .ngc
-- @params projectname Name of the project, i.e. "myProject" 
function init(projectname)
	if projectname == nil then projectname = "luacrumbs-project" end
	crumbs_projectname = projectname
	
	crumbs_circlemode = 1 -- set circlemode to radius, not corner
	
	standardInit(false)
	--setSpeed(1200)
	
	outerx = 0
	outery = 0
end

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

--- Move to absolute coordinate (every parameter is optional. If nil, the xyz value is unchanged)
-- TODO: Please test this with only one or zero parameters with an g-code device
-- @params xpos Move to absolute x-position. If nil, the x-value is unchanged
-- @params ypos Move to absolute y-position. If nil, the y-value is unchanged
-- @params zpos Move to absolute z-position. If nil, the z-value is unchanged
function moveTo(xpos, ypos, zpos)
	crumbs_gcode = crumbs_gcode.."G1"
	if xpos ~= nil then crumbs_gcode = crumbs_gcode.." x"..xpos end
	if ypos ~= nil then crumbs_gcode = crumbs_gcode.." y"..ypos end
	if zpos ~= nil then crumbs_gcode = crumbs_gcode.." z"..zpos end
	crumbs_gcode = crumbs_gcode.."\n"
	
	if crumbs_generate_html3d then
		if xpos == nil then
			xpos = curx
		end
		if ypos == nil then
			ypos = cury
		end
		if zpos == nil then
			zpos = curz
		end
		-- don't draw redundant lines
		if xpos == curx and ypos == cury and zpos == curz then
			-- do nothing
		else
			crumbs_pde3d = crumbs_pde3d.."line("..curx..", "..cury..", "..curz..", "..xpos..", "..ypos..", "..zpos..");\n"
		end
	end
	
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

--- Draw circle, counterclockwise-parameter is optional
-- @params radius (number) Radius to draw
-- @params counterclockwise (bool) Draw counterclockwise (optional)
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
	
	if crumbs_generate_html3d then
		crumbs_html3d = crumbs_html3d.."\n" -- Do Processing
		if counterclockwise then 
			crumbs_html3d = crumbs_html3d.."\n"
		else
			crumbs_html3d = crumbs_html3d.."\n"
		end
		crumbs_html3d = crumbs_html3d.."\n"
	end
	
	if crumbs_generate_svg then
		crumbs_svg = crumbs_svg.."<circle cx=\""..curx.."\" cy=\""..(cury+(radius)).."\" r=\""..radius.."\" stroke=\"black\" fill=\"rgb(255,255,255)\" fill-opacity=\"0.0\" stroke-width=\"1px\"/>\n"
	end
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."CI"..(radius*hpgl_scale)..";"
	end
end

--- Pause the drawing in seconds
-- Currently only in G-Code 
-- @params seconds (number) seconds to pause. Parameter must be a positive number.
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

--- Generates a html-5 preview file.
-- The generated file can be opened in any html5-canvas ready browser, to preview the output if the g-code.
-- Notice: The framework only draws a line on canvas, of the z-position is equal to the pencilDown-position. If you use i.e. moveTo-commands, be sure to call pencilDown() beforehand, otherwise there will be no drawn path.
-- @params flag: true or false
-- @params zoom_factor: (optional) scale the output with this zoom-factor. Default: 1
-- @params line_width: (optional) Set the line-width of the drawn-path.
function generateHTML(flag, zoom_factor, line_width)
	crumbs_generate_html = flag
	if (zoom_factor ~= nil) then
		html_zoom = zoom_factor	
	end
	if (line_width ~= nil) then
		html_linewidth = line_width	
	end
end

local function doGenerateHTML()
	print("\nStarting to write html-file.")
	output_file = crumbs_projectname..".html"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
		
	file:write("<html>\n")
	file:write("<head>\n")
	file:write("<title>"..output_file.." - Made with LuaCrumbs</title>\n")
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

--- Generates a html-3d preview file for webGL enabled browser. Try latest Firefox or Chromium.
-- Open the html-file in Firefox or Chromium.
-- @params flag: true or false
function generateHTML3D(flag)
	crumbs_generate_html3d = flag
end

local function doGenerateHTML3D()
	print("\nStarting to write html3D-file.")
	output_file = crumbs_projectname.."-3d.html"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
		
	file:write("<html>\n")
	file:write("<head>\n")
	file:write("<title>"..output_file.." - Made with LuaCrumbs - nodepond.com</title>\n")
	file:write("</head>\n")
	file:write("<body>\n")
	--file:write("<canvas id=\"c\" width=\""..(outerx+html_linewidth+1)*html_zoom.."\" height=\""..(outery+html_linewidth+1)*html_zoom.."\"></canvas>\n")
	file:write("<script src=\"./3rdparty/processing-1.3.6.min.js\"></script>\n")
	file:write("<canvas data-processing-sources=\""..crumbs_projectname..".pde\"></canvas>\n")
	file:write(crumbs_html3d)
	file:write("</body>\n")
	file:write("</html>\n")
	print("Writing of "..output_file.." complete.\n")	
	
	print("\nStarting to write processingjs-file.")
	output_file = crumbs_projectname..".pde"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	
	file:write("boolean isRotating = false;\n")
	file:write("boolean alternateColors = false;\n")
	file:write("float incx = 0.;\n")
	file:write("float incy = 0.;\n")
	file:write("float middlex;\n")
	file:write("float middley;\n")
	file:write("float middlez;\n")
	file:write("float rotX = 0.;\n")
	file:write("float rotY = 0.;\n")
	file:write("void setup() {\n")
	file:write("	size(800, 600, OPENGL);\n")
	file:write("	fill(184, 235, 184);\n")
	file:write("}\n")
	file:write("\n")
	file:write("void draw() {\n")
	file:write("	lights();\n")
	file:write("	if (alternateColors) {\n")
	file:write("		background(120);\n")
	file:write("	} else {\n")
	file:write("		background(255);\n")
	file:write("	}\n")
	file:write("	camera(0.0, middlez, 220.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);\n")
	file:write("	if (mousePressed) {\n")
	file:write("	// do nothing\n")
	file:write("	} else {\n")
	file:write("	rotX = (PI*2)*((mouseX/(float)width)+incx);\n")
	file:write("	rotY = (PI*2)*((mouseY/(float)width)+incy);\n")
	file:write("	}\n")
	file:write("	translate(middlex, middley, 0.);\n")
	file:write("	rotateX(rotX);\n")
	file:write("	rotateY(rotY);\n")
	file:write("	translate(-middlex, -middley, -0.);\n")
	file:write("	\n")
	file:write("	if (isRotating) {\n")
	file:write("		incx += 0.0003;\n")
	file:write("		if (incx >= 1.0) {\n")
	file:write("			incx = 0.;\n")
	file:write("		}\n")
	file:write("		incy += 0.001;\n")
	file:write("		if (incy >= 1.0) {\n")
	file:write("			incy = 0.;\n")
	file:write("		}\n")
	file:write("	}\n")
	file:write("	if (alternateColors) {\n")
	file:write("		stroke(120, 0, 0);\n")
	file:write("	} else {\n")
	file:write("		stroke(40, 120, 40);\n")
	file:write("	}\n")
	file:write("	line(-100, 0, 0, 100, 0, 0);\n")
	file:write("	line(0, -100, 0, 0, 100, 0);\n")
	file:write("	line(0, 0, -100, 0, 0, 100);\n")
	file:write("	if (alternateColors) {\n")
	file:write("		stroke(0);\n")
	file:write("	} else {\n")
	file:write("		stroke(0);\n")
	file:write("	}\n")
	file:write(crumbs_pde3d) -- insert the custom code
	file:write("	noStroke();\n")
	file:write("	if (alternateColors) {\n")
	file:write("		fill(180, 180, 180, 120);\n")
	file:write("	} else {\n")
	file:write("		fill(120, 120, 120, 180);\n")
	file:write("	}\n")
	file:write("	translate(0,0,-50);\n")
	file:write("	box(200,200,100);\n")
	file:write("	translate(0,0,50);\n")
	file:write("}\n")
	file:write("void mouseDragged() {\n")
	file:write("	middlex += mouseX - pmouseX;\n")
	file:write("	middley += mouseY - pmouseY;\n")
	file:write("}\n")
	file:write("void keyPressed() {\n")
	file:write("	if (keyCode == UP) {\n")
	file:write("		middlez += 15.0;\n")
	file:write("	}\n")
	file:write("	if (keyCode == DOWN) {\n")
	file:write("		middlez -= 15.0;\n")
	file:write("	}\n")
	file:write("	if (key == 'r' || key == 'R') {\n")
	file:write("		if (isRotating) {\n")
	file:write("			isRotating = false;\n")
	file:write("		} else {\n")
	file:write("			isRotating = true;\n")
	file:write("		}\n")
	file:write("	}\n")
	file:write("	if (key == 'c' || key == 'C') {\n")
	file:write("		if (alternateColors) {\n")
	file:write("			alternateColors = false;\n")
	file:write("		} else {\n")
	file:write("			alternateColors = true;\n")
	file:write("		}\n")
	file:write("	}\n")
	file:write("}\n")
	
	print("Writing of "..output_file.." complete.\n")
end

--- Should LuaCrumbs generate a ngc-file (G-Code). The default is yes, since it is intended to use LuaCrumbs with G-Code!
-- @params flag: true or false
function generateGCode(flag)
	crumbs_generate_gcode = flag
end

local function doGenerateGCode()
	print("\nStarting to write GCode-file.")
	output_file = crumbs_projectname..".ngc"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)			
	file:write(crumbs_gcode)
	file:close()
	print("Writing of "..output_file.." complete.\n")	
end

--- Should LuaCrumbs generate a svg-file. The default is no.
-- @params flag: true or false
function generateSVG(flag)
	crumbs_generate_svg = flag
end

local function doGenerateSVG()
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

--- Should LuaCrumbs generate a hpgl-file (HPGL). The default is no.
-- @params flag: true or false
function generateHPGL(flag)
	crumbs_generate_hpgl = flag
end

local function doGenerateHPGL()
	print("\nStarting to write HPGL-file.")
	output_file = crumbs_projectname..".hpgl"
	file = io.open(output_file, "w+")
	print("Opened file: "..output_file)	
	crumbs_hpgl = crumbs_hpgl .. "E;"		
	file:write(crumbs_hpgl)
	file:close()
	print("Writing of "..output_file.." complete.\n")	
end

--- Close the project. This command is mandatory!
-- Call this function at the end of your lua-script. It is a must, because ending-tags and diffrerent other parameters are written here.
-- Without this closing statement, you will not get corrently generated files! (In fact, that are not generated at all)
function close()	
	if crumbs_generate_gcode then		
		crumbs_gcode = crumbs_gcode.."M2\n" -- is this call maybe in the wrong place?
		doGenerateGCode()
	end
		
	if crumbs_generate_html then
		doGenerateHTML()
	end
	
	if crumbs_generate_html3d then
		doGenerateHTML3D()
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

--- Setter of the pencil up position
-- Sets the pencil up position
-- @params zpos (number) pencil up position
function setPencilUpPosition(zpos)
	crumbs_penciluppos = zpos
	-- avoid, that pencilUp is below the pencilDown position
	if crumbs_penciluppos <= crumbs_pencildownpos then
		crumbs_penciluppos = crumbs_pencildownpos
	end
end

--- Setter of the pencil down position
-- Sets the pencil down position
-- @params zpos (number) pencil down position
function setPencilDownPosition(zpos)
	crumbs_pencildownpos = zpos
	-- avoid, that pencilDown is above the pencilUp position
	if crumbs_pencildownpos >= crumbs_penciluppos then
		crumbs_pencildownpos = crumbs_penciluppos
	end
end

--- Getter of the pencil up position
-- Gets the current pencil up position, returns a number
function getPencilUpPosition()
	return crumbs_penciluppos
end
--- Getter of the pencil up position
-- Gets the current pencil up position, returns a number
function getPencilDownPosition()
	return crumbs_pencildownpos
end

local function moveToZPosition(zpos)
	moveTo(nil, nil, zpos)
end

--- Moves the pencil to pencilup-position (z-axis)  
-- Move the head up and down with pencilUp() and pencilDown()
function pencilUp()
	moveToZPosition(crumbs_penciluppos)
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."PU;"
	end
end

--- Moves the pencil to pencildown-position (z-axis)  
-- Move the head up and down with pencilUp() and pencilDown()
function pencilDown()
	moveToZPosition(crumbs_pencildownpos)
	
	if crumbs_generate_hpgl then
		crumbs_hpgl = crumbs_hpgl.."PD;"
	end
end

--- Checks, if pencil is currently at drawing (z) position  
-- Returns true, if the pencil is currently at the drawing-position, aka pencildown-position, otherwise false.
function isPencilDown()
	return curz == crumbs_pencildownpos
end

-- NOTICE: line and lineTo are still problematic, because tey take move-to into account, but are not always "drawn". 
-- This is a little ugly dependency, also that there is an 'if crumbs_generate_html then'-statement at this place. 
-- This kind of statements should be only in the Core!!

--- Draws a line from start X/Y-position to X/Y-destination position. 
-- Before starting to draw, the drawing-head is always moved up to up-position (z-axis), aka pencilUp.
-- When drawing starts, the head is put down to down-position aka pencilDown. If pencil is not down, it will go down.
-- @param xstart X-start-position in absolute coordinates
-- @param ystart Y-start-position in absolute coordinates
-- @param xdest X-destination in absolute coordinates
-- @param ydest Y-destination in absolute coordinates
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

--- Draw a line straight from recent position to X/Y-destination.
-- If pencil is not down, it will go down.
-- @param xpos X-Position of destination in absolute coordinates
-- @param ypos Y-Position of destination in absolute coordinates
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

--- Draw a circle at a specified position 
-- @param xpos X-position of the circle-center.
-- @param ypos Y-position of the circle-center.
-- @param radius Radius of the circle.
-- @param counterclockwise (Optional) parameter. If true, the circle gets drawn counter-clockwise (not supported on all lanuages). The default value is nil (or false).
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
-- @param degrees Degrees to add to th current rotation. Value can be positive and negative as well.
function addRotation(degrees)
	rotation = rotation + degrees
end

--- Sets the rotation directly to the specified value 
-- @param degrees Degrees to set. Value should be between -360 and 360.
function setRotation(degrees)
	rotation = degrees
end

--- Get the rotation parameter 
-- Returns the recent rotation-value
function getRotation()
	return rotation
end

--- Getter of x
-- Returns the current x-value
function getX()
	return curx
end

--- Getter of y
-- Returns the current y-value
function getY()
	return cury
end

--- Getter of z
-- Returns the current z-value
function getZ()
	return curz
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
-- TODO: This function is currently not implemented!
function moveBackward(steps)
	
end


--- RepRap-related commands
-- Doc: http://reprap.org/wiki/Mendel_User_Manual:_RepRapGCodes
function setTemparatur()
end

function homeAllAxes()
end

-- GCode-Commands

--- Insert whatever you want onto a G-Code file
-- Universal function to write something into the gcode file, i.e. custom commands like "M101"
function insertIntoGCodeFile(string)
	crumbs_gcode = crumbs_gcode..string.."\n"
end


--- GCode: Use Path Tolerance Mode
-- @params flag - true or false. If true, path tolerance mode is selected. It inserts a "G64" command into the CGode-file
-- G64-Mode is much faster in moving the head, but to the cost of possible errors in drawing the path - means it can be not 100% accurate on the path.
-- If set to false, the GCode-command "G61" is inserted into the GCode-file. This switches the machine back to "exact path drawing" mode.
function setGCodeUsePathTolanceMode(flag)
	if (flag) then
		crumbs_gcode = crumbs_gcode.."G64\n"
	else
		crumbs_gcode = crumbs_gcode.."G61\n"
	end
end

--- Set the speed-parameter in G-Code file
-- @params val Set the speed-parameter, if nil or 0, G0 for maximum speed is added to the G-Code
function setGCodeSpeed(val)
	if val == nil or val == 0 then
		crumbs_gcode = crumbs_gcode.."G0\n"
		return
	end
	if val > 0 then
		crumbs_gcode = crumbs_gcode.."F"..val.."\n"
	end
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



