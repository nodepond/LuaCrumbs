-- This is the very first test of the framework
-- sep/okt 2011 / martin wisniowski

require("particles")

particles.init("test.ngc", true)

-- jump straight into the fun!
particles.line(0, 0, 100, 100)
particles.line(0, 100, 100, 0)
particles.circleAt(50, 50, 12)

particles.setPencilDownPosition(-5)
particles.circleAt(50, 50, 12, true)
particles.setPencilDownPosition(-10)
particles.circleAt(50, 50, 8, true)

particles.circleAt(0, 0, 50, true)
particles.circleAt(0, 0, 10, true)

particles.close()
