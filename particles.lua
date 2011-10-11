-----------------------------------------------------------------------------
-- Particles.lua
-- Scripting-libary for generating G-Code for CNC-machines.
-- Jump straight into the fun!
-- http://particles.nodepond.com
--
-- License: MIT/X
-- 
-- (c) 2011 Nodepond / Martin Wisniowski (hello@nodepond.com)
--
-----------------------------------------------------------------------------


module(..., package.seeall)

-- Core (Really most basic functions)

-- define some variables for config and control
particles_circlemode = 0 -- particles_circlemode: 0 = corner, 1 = radius
particles_generate_html = true -- generate html output file?
particles_html = "" -- the content, that is added to the html-file
particles_filename = ""

-- keep track of the current positions (we need this in some occations)
curx = 0
cury = 0
curz = 0

-- additional canvas / html5 parameters
html_zoom = 4

function standardInit(verbose)
	-- this is the standard init
	if verbose then
		file:write("G40 (disable tool radius compensation)\n")
		file:write("G49 (disable_tool_length_compensation)\n")
		file:write("G80 (cancel_modal_motion)\n")
		file:write("G54 (select_coordinate_system_1)\n")
		file:write("G90 (Absolute distance mode)\n") -- "incremental motion"
		file:write("G21 (metric)\n")
		file:write("G61 (exact path mode)\n")
	else -- comment: is there any real reason for shortening and therefore obfuscinating the g.code?!
		file:write("G40\n")
		file:write("G49\n")
		file:write("G80\n")
		file:write("G54\n")
		file:write("G90\n")
		file:write("G21\n")
		file:write("G61\n")
	end
end

function setSpeed(val)
	if val == nil or val == 0 then
		file:write("G0\n")
		return
	end
	if val > 0 then
		file:write("F"..val.."\n")
	end
end

-- Move to absolute coordinate (every parameter is optional. If nil, the xyz value is unchanged)
-- TODO: Please test this with only one or zero parameters with an g-code device
function moveTo(xpos, ypos, zpos)
	file:write("G1")
	if xpos ~= nil then file:write(" x"..xpos) end
	if ypos ~= nil then file:write(" y"..ypos) end
	if zpos ~= nil then file:write(" z"..zpos) end
	file:write("\n")
	
	-- update the current position
	if xpos ~= nil then curx = xpos end
	if ypos ~= nil then cury = ypos end
	if zpos ~= nil then curz = zpos end
end

-- Draw circle, counterclockwise-parameter is optional
function circle(radius, counterclockwise)
	if counterclockwise == true then
		file:write("G3 J"..radius.."\n")
	else
		file:write("G2 J"..radius.."\n")
	end
	
	if particles_generate_html then
		particles_html = particles_html.."context.beginPath();\n"
		particles_html = particles_html.."context.arc("..(curx)*html_zoom..", "..(cury+radius)*html_zoom..", "..(radius)*html_zoom..", 0, Math.PI * 2, false);\n"
		particles_html = particles_html.."context.closePath();\n"
		if counterclockwise then 
			particles_html = particles_html.."context.strokeStyle = \"#999\";\n"
			particles_html = particles_html.."context.lineWidth = 4;\n" -- visually show, that this is a counterclockwise circle
		else
			particles_html = particles_html.."context.strokeStyle = \"#666\";\n"
			particles_html = particles_html.."context.lineWidth = 2;\n"
		end
		particles_html = particles_html.."context.stroke();\n"
		particles_html = particles_html.."context.strokeStyle = \"#666\";\n" -- in any case, back to default
		particles_html = particles_html.."context.lineWidth = 2;\n"
		
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
	file:write("G4 P"..seconds.."\n")
end
-- verbose = true or false
function init(output_file, verbose)
	if output_file == nil then output_file = "output.txt" end
	particles_filename = output_file
	file = io.open(output_file, "w+")
	print("\nOpened file: "..output_file)
	
	particles_circlemode = 1 -- set circlemode to radius, not corner
	
	standardInit(verbose)
	setSpeed(1200)
end

-- universal function to write something into the gcode file, i.e. custom commands like "M101"
function writeToFile(string)
	file:write(string.."\n")	
end

--- Should Particles generate an additional html5-file, that visualises the content?
-- The generated file can be opened in any html5-canvas ready browser, to preview the output if the g-code
-- @params flag: true or false
function generateHTML(flag)
	particles_generate_html = flag
end

function doGenerateHTML()
		print("\nStarting to write html-file.")
		output_file = particles_filename..".html"
		file = io.open(output_file, "w+")
		print("Opened file: "..output_file)	
		
		file:write("<html>\n")
		file:write("<head>\n")
		file:write("<title>"..output_file.." - made with Particles G-Code Generator</title>\n")
		file:write("</head>\n")
		file:write("<body>\n")
		file:write("<canvas id=\"c\" width=\"600\" height=\"600\"></canvas>\n")
		file:write("<script>\n")
		file:write("var c = document.getElementById(\"c\");\n")
		file:write("var context = c.getContext(\"2d\");\n")
		file:write("context.strokeStyle = \"#666\";\n")
		file:write("context.lineWidth = 2;\n")		
		file:write(particles_html)
		file:write("</script>\n")
		file:write("</body>\n")
		file:write("</html>\n")
		print("Writing of "..output_file.." complete.\n")	
end

function close()
	file:write("M2\n")
	file:close()
	print("Writing of file complete.\n")
	
	if particles_generate_html then
		doGenerateHTML()
	end
end
-- Core (Really most basic functions) END

particles_penciluppos = 30
particles_pencildownpos = 0

-- Drawing Core (first layer upon core: simple "2D/3D" drawing functions)
function setPencilUpPosition(zpos)
	particles_penciluppos = zpos
end

function setPencilDownPosition(zpos)
	particles_pencildownpos = zpos
end

function getPencilUpPosition()
	return particles_penciluppos
end

function getPencilDownPosition()
	return particles_pencildownpos
end

function moveToZPosition(zpos)
	moveTo(nil, nil, zpos)
end

function pencilUp()
	moveToZPosition(particles_penciluppos)
end

function pencilDown()
	moveToZPosition(particles_pencildownpos)
end

-- draw line: mode to up, go to start pos, move down, draw line to dest
function line(xstart, ystart, xdest, ydest)
	pencilUp()
	moveTo(xstart, ystart)
	pencilDown()
	moveTo(xdest, ydest)	
	
	if particles_generate_html then
		-- we currently only support "2d-drawing"
		particles_html = particles_html.."context.moveTo(".. xstart*html_zoom ..", ".. ystart*html_zoom ..");\n"
		particles_html = particles_html.."context.lineTo(".. xdest*html_zoom ..", ".. ydest*html_zoom ..");\n"
		particles_html = particles_html.."context.stroke();\n"
	end
end

-- draw line: straight from recent position. If pencil is not down, it will go down.
function lineTo(xpos, ypos)
	pencilDown() -- if down, nothing should happen
	moveTo(xpos, ypos)
	
	if particles_generate_html then
		-- we currently only support "2d-drawing"
		particles_html = particles_html.."context.lineTo(".. xpos*html_zoom ..", ".. ypos*html_zoom ..");\n"
		particles_html = particles_html.."context.stroke();\n"
	end
end

-- counterclockwise is optional
function circleAt(xpos, ypos, radius, counterclockwise)	
	pencilUp()
	if particles_circlemode == 0 then
		moveTo(xpos, ypos)	  
	elseif particles_circlemode == 1 then
		moveTo(xpos, ypos-(radius))
	end
	pencilDown()
	circle(radius, counterclockwise)
end
