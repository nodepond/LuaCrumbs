boolean isRotating = false;
boolean isRotatingX = false;
boolean isRotatingY = false;
boolean isRotatingZ = true;
boolean alternateColors = false;
float incx = 0.;
float incy = 0.;
float incz = 0.;
float middlex;
float middley;
float middlez;
float rotX = 0.;
float rotY = 0.;
float rotZ = 0.;
void setup() {
	size(800, 600, OPENGL);
	fill(184, 235, 184);
}

void draw() {
	lights();
	if (alternateColors) {
		background(120);
	} else {
		background(255);
	}
	camera(0.0, middlez, 220.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
	if (mousePressed) {
	// do nothing
	} else {
	rotY = (PI*2)*((mouseX/(float)width)+incx);
	rotX = (PI*2)*((mouseY/(float)height)+incy);
	rotZ = (PI*2)*incz;
	}
	translate(middlex, middley, 0.);
	rotateX(rotX);
	rotateY(rotY);
	rotateZ(rotZ);
	translate(-middlex, -middley, -0.);
	
	if (isRotating) {
	if (isRotatingX) { incx += 0.0003; };
		if (incx >= 1.0) {
			incx = 0.;
		}
	if (isRotatingY) { incy += 0.0001; };
		if (incy >= 1.0) {
			incy = 0.;
		}
	if (isRotatingZ) { incz += 0.00045; };
		if (incz >= 1.0) {
			incz = 0.;
		}
	}
	if (alternateColors) {
		stroke(120, 0, 0);
	} else {
		stroke(40, 120, 40);
	}
	line(-50, 0, 0, 50, 0, 0);
	line(0, -50, 0, 0, 50, 0);
	line(0, 0, -50, 0, 0, 50);
	if (alternateColors) {
		stroke(0);
	} else {
		stroke(0);
	}
line(0, 0, 0, 0, 0, 30);
line(0, 0, 30, 0, 0, 0);
line(0, 0, 0, 3.0616169978684e-16, -5, 0);
line(3.0616169978684e-16, -5, 0, 0.0087266418294916, -9.9999923845664, 0);
line(0.0087266418294916, -9.9999923845664, 0, 0.11343874124628, -14.998895801941, 0);
line(0.11343874124628, -14.998895801941, 0, 0.40125887604411, -19.990604885011, 0);
line(0.40125887604411, -19.990604885011, 0, 0.95860353707574, -24.959444480814, 0);
line(0.95860353707574, -24.959444480814, 0, 1.8697811645365, -29.875719018634, 0);
line(1.8697811645365, -29.875719018634, 0, 3.2143802676128, -34.691531852622, 0);
line(3.2143802676128, -34.691531852622, 0, 5.063114053982, -39.337194710292, 0);
line(5.063114053982, -39.337194710292, 0, 7.4718824244905, -43.718728110511, 0);
line(7.4718824244905, -43.718728110511, 0, 10.47398355112, -47.717151402947, 0);
line(10.47398355112, -47.717151402947, 0, 14.070682552813, -51.190443255242, 0);
line(14.070682552813, -51.190443255242, 0, 18.22074397829, -53.97916880014, 0);
line(18.22074397829, -53.97916880014, 0, 22.830059736233, -55.916746732401, 0);
line(22.830059736233, -55.916746732401, 0, 27.743123718951, -56.845079809329, 0);
line(27.743123718951, -56.845079809329, 0, 32.738737869445, -56.635701540683, 0);
line(32.738737869445, -56.635701540683, 0, 37.532836543786, -55.215624817163, 0);
line(37.532836543786, -55.215624817163, 0, 41.791471214501, -52.595695287313, 0);
line(41.791471214501, -52.595695287313, 0, 45.15653378205, -48.89753981242, 0);
line(45.15653378205, -48.89753981242, 0, 47.285430239875, -44.37340455009, 0);
line(47.285430239875, -44.37340455009, 0, 47.903437623578, -39.411744860662, 0);
line(47.903437623578, -39.411744860662, 0, 46.863879169489, -34.521006856993, 0);
line(46.863879169489, -34.521006856993, 0, 44.206886271899, -30.285397250082, 0);
line(44.206886271899, -30.285397250082, 0, 40.203229417155, -27.290279257504, 0);
line(40.203229417155, -27.290279257504, 0, 35.366890653276, -26.02148953458, 0);
line(35.366890653276, -26.02148953458, 0, 30.420528988461, -26.751904677393, 0);
line(30.420528988461, -26.751904677393, 0, 26.203571759396, -29.438402719127, 0);
line(26.203571759396, -29.438402719127, 0, 23.524437784501, -33.660042346637, 0);
line(23.524437784501, -33.660042346637, 0, 22.975766229046, -38.629847123913, 0);
line(22.975766229046, -38.629847123913, 0, 24.751301041087, -43.303975505893, 0);
line(24.751301041087, -43.303975505893, 0, 28.519118002595, -46.590851734863, 0);
line(28.519118002595, -46.590851734863, 0, 33.409856006264, -47.630410188952, 0);
line(33.409856006264, -47.630410188952, 0, 38.162434664403, -46.077028040798, 0);
line(38.162434664403, -46.077028040798, 0, 41.429537684353, -42.292052762539, 0);
line(41.429537684353, -42.292052762539, 0, 42.185841785589, -37.349583328496, 0);
line(42.185841785589, -37.349583328496, 0, 40.120319636467, -32.796165024465, 0);
line(40.120319636467, -32.796165024465, 0, 35.857118814696, -30.183672200885, 0);
line(35.857118814696, -30.183672200885, 0, 30.866985172555, -30.497624798532, 0);
line(30.866985172555, -30.497624798532, 0, 27.01998739732, -33.69146388611, 0);
line(27.01998739732, -33.69146388611, 0, 25.878233046767, -38.559358400476, 0);
line(25.878233046767, -38.559358400476, 0, 27.983412113605, -43.094578471933, 0);
line(27.983412113605, -43.094578471933, 0, 32.4773823451, -45.286434205879, 0);
line(32.4773823451, -45.286434205879, 0, 32.4773823451, -45.286434205879, 30);
line(32.4773823451, -45.286434205879, 30, 15, 15, 30);
line(15, 15, 30, 15, 15, 0);
line(15, 15, 0, 22.758976122278, 16.948920094288, 0);
line(22.758976122278, 16.948920094288, 0, 30.514538921439, 18.911379181319, 0);
line(30.514538921439, 18.911379181319, 0, 38.230998269101, 21.022363581042, 0);
line(38.230998269101, 21.022363581042, 0, 45.864920897232, 23.41468991909, 0);
line(45.864920897232, 23.41468991909, 0, 53.358298411219, 26.216348969166, 0);
line(53.358298411219, 26.216348969166, 0, 60.632187283595, 29.54659530725, 0);
line(60.632187283595, 29.54659530725, 0, 67.581239399101, 33.510264654709, 0);
line(67.581239399101, 33.510264654709, 0, 74.069749951015, 38.189926054607, 0);
line(74.069749951015, 38.189926054607, 0, 79.930093141314, 43.635693006278, 0);
line(79.930093141314, 43.635693006278, 0, 84.964656269713, 49.852860697934, 0);
line(84.964656269713, 49.852860697934, 0, 88.952558187744, 56.788034689419, 0);
line(88.952558187744, 56.788034689419, 0, 91.662461549706, 64.315080841053, 0);
line(91.662461549706, 64.315080841053, 0, 92.872548111683, 72.223031935522, 0);
line(92.872548111683, 72.223031935522, 0, 92.398097123076, 80.208950558912, 0);
line(92.398097123076, 80.208950558912, 0, 90.125974365444, 87.879508437858, 0);
line(90.125974365444, 87.879508437858, 0, 86.053643039441, 94.765444653889, 0);
line(86.053643039441, 94.765444653889, 0, 80.328101169811, 100.35276693734, 0);
line(80.328101169811, 100.35276693734, 0, 73.277673553291, 104.13317305629, 0);
line(73.277673553291, 104.13317305629, 0, 65.427332241353, 105.6733487885, 0);
line(65.427332241353, 105.6733487885, 0, 57.486963028223, 104.69839404126, 0);
line(57.486963028223, 104.69839404126, 0, 50.302742422138, 101.17888068241, 0);
line(50.302742422138, 101.17888068241, 0, 44.765597031175, 95.404798857621, 0);
line(44.765597031175, 95.404798857621, 0, 41.67834869258, 88.024494141971, 0);
line(41.67834869258, 88.024494141971, 0, 41.59457441965, 80.024932787047, 0);
line(41.59457441965, 80.024932787047, 0, 44.656041878571, 72.633896526957, 0);
line(44.656041878571, 72.633896526957, 0, 50.468639246339, 67.137196440521, 0);
line(50.468639246339, 67.137196440521, 0, 58.064043067474, 64.625256792782, 0);
line(58.064043067474, 64.625256792782, 0, 65.990025791246, 65.710981372256, 0);
line(65.990025791246, 65.710981372256, 0, 72.551240798236, 70.288148359821, 0);
line(72.551240798236, 70.288148359821, 0, 76.183164796152, 77.416200553328, 0);
line(76.183164796152, 77.416200553328, 0, 75.8900151265, 85.410827703557, 0);
line(75.8900151265, 85.410827703557, 0, 71.627004917934, 92.180373032577, 0);
line(71.627004917934, 92.180373032577, 0, 64.480033811311, 95.774925021505, 0);
line(64.480033811311, 95.774925021505, 0, 56.515538094487, 95.022058514956, 0);
line(56.515538094487, 95.022058514956, 0, 50.254672839667, 90.041941421856, 0);
line(50.254672839667, 90.041941421856, 0, 47.862346501619, 82.408018793725, 0);
line(47.862346501619, 82.408018793725, 0, 50.294610989022, 74.786726943697, 0);
line(50.294610989022, 74.786726943697, 0, 56.750293486173, 70.061881602737, 0);
line(56.750293486173, 70.061881602737, 0, 64.749306546026, 70.187540141232, 0);
line(64.749306546026, 70.187540141232, 0, 70.966474237682, 75.22210326963, 0);
line(70.966474237682, 75.22210326963, 0, 72.616107720855, 83.050175150444, 0);
line(72.616107720855, 83.050175150444, 0, 72.616107720855, 83.050175150444, 30);
line(72.616107720855, 83.050175150444, 30, 30, 30, 30);
line(30, 30, 30, 30, 30, 0);
line(30, 30, 0, 29.054898470262, 31.76260690413, 0);
line(29.054898470262, 31.76260690413, 0, 28.100580949743, 33.520241129454, 0);
line(28.100580949743, 33.520241129454, 0, 27.106633027688, 35.255772036192, 0);
line(27.106633027688, 35.255772036192, 0, 26.043835868652, 36.950015878956, 0);
line(26.043835868652, 36.950015878956, 0, 24.885273523966, 38.580271470413, 0);
line(24.885273523966, 38.580271470413, 0, 23.607737888935, 40.119070580507, 0);
line(23.607737888935, 40.119070580507, 0, 22.193524326562, 41.53328414288, 0);
line(22.193524326562, 41.53328414288, 0, 20.632663511885, 42.783769455552, 0);
line(20.632663511885, 42.783769455552, 0, 18.925561917335, 43.825788719233, 0);
line(18.925561917335, 43.825788719233, 0, 17.085918922691, 44.61046295244, 0);
line(17.085918922691, 44.61046295244, 0, 15.143650362872, 45.087529867597, 0);
line(15.143650362872, 45.087529867597, 0, 13.147380766028, 45.209626946667, 0);
line(13.147380766028, 45.209626946667, 0, 11.165885085085, 44.938195801798, 0);
line(11.165885085085, 44.938195801798, 0, 9.287696580896, 44.250876412627, 0);
line(9.287696580896, 44.250876412627, 0, 7.6180008543691, 43.149914932457, 0);
line(7.6180008543691, 43.149914932457, 0, 6.2719758273495, 41.6706527425, 0);
line(6.2719758273495, 41.6706527425, 0, 5.3639948278704, 39.888639694123, 0);
line(5.3639948278704, 39.888639694123, 0, 4.9926615970992, 37.923414101036, 0);
line(4.9926615970992, 37.923414101036, 0, 5.2225358980848, 35.936668569835, 0);
line(5.2225358980848, 35.936668569835, 0, 6.0646075248197, 34.122580541252, 0);
line(6.0646075248197, 34.122580541252, 0, 7.4589377305288, 32.688759325951, 0);
line(7.4589377305288, 32.688759325951, 0, 9.2641082992285, 31.827737132335, 0);
line(9.2641082992285, 31.827737132335, 0, 11.258737253677, 31.681260738079, 0);
line(11.258737253677, 31.681260738079, 0, 13.159768716933, 32.302613597341, 0);
line(13.159768716933, 32.302613597341, 0, 14.659990856194, 33.625237327988, 0);
line(14.659990856194, 33.625237327988, 0, 15.483019573404, 35.448043881259, 0);
line(15.483019573404, 35.448043881259, 0, 15.44811476053, 37.447739271572, 0);
line(15.44811476053, 37.447739271572, 0, 14.530815651561, 39.224973736882, 0);
line(14.530815651561, 39.224973736882, 0, 12.900560060104, 40.383536081567, 0);
line(12.900560060104, 40.383536081567, 0, 10.915896184333, 40.630739035048, 0);
line(10.915896184333, 40.630739035048, 0, 9.0641550147132, 39.875057461411, 0);
line(9.0641550147132, 39.875057461411, 0, 7.8466321566957, 38.288350780829, 0);
line(7.8466321566957, 38.288350780829, 0, 7.6306334452836, 36.300048852884, 0);
line(7.6306334452836, 36.300048852884, 0, 8.5105117849954, 34.503993701363, 0);
line(8.5105117849954, 34.503993701363, 0, 10.231995839003, 33.485910869862, 0);
line(10.231995839003, 33.485910869862, 0, 12.227827075548, 33.614975486368, 0);
line(12.227827075548, 33.614975486368, 0, 13.782118998462, 34.873616268468, 0);
line(13.782118998462, 34.873616268468, 0, 14.289634887631, 36.808151774019, 0);
line(14.289634887631, 36.808151774019, 0, 13.521044242312, 38.654572208245, 0);
line(13.521044242312, 38.654572208245, 0, 11.773499796241, 39.627242969092, 0);
line(11.773499796241, 39.627242969092, 0, 9.8051085803022, 39.273073488453, 0);
line(9.8051085803022, 39.273073488453, 0, 9.8051085803022, 39.273073488453, 30);
line(9.8051085803022, 39.273073488453, 30, -45, 30, 30);
line(-45, 30, 30, -45, 30, 0);
line(-45, 30, 0, -48.816469321667, 25.370252499674, 0);
line(-48.816469321667, 25.370252499674, 0, -52.360103327386, 20.528490626811, 0);
line(-52.360103327386, 20.528490626811, 0, -55.53073333572, 15.434660501036, 0);
line(-55.53073333572, 15.434660501036, 0, -58.217287862753, 10.06973508, 0);
line(-58.217287862753, 10.06973508, 0, -60.298901772192, 4.4424014723284, 0);
line(-60.298901772192, 4.4424014723284, 0, -61.648608098255, -1.4038189163831, 0);
line(-61.648608098255, -1.4038189163831, 0, -62.140239150035, -7.3836432372913, 0);
line(-62.140239150035, -7.3836432372913, 0, -61.659045604062, -13.364316508029, 0);
line(-61.659045604062, -13.364316508029, 0, -60.116248845134, -19.162572983957, 0);
line(-60.116248845134, -19.162572983957, 0, -57.467213728383, -24.546123202003, 0);
line(-57.467213728383, -24.546123202003, 0, -53.732125908557, -29.241772143117, 0);
line(-53.732125908557, -29.241772143117, 0, -49.016984549505, -32.952222515262, 0);
line(-49.016984549505, -32.952222515262, 0, -43.531460818099, -35.383072035941, 0);
line(-43.531460818099, -35.383072035941, 0, -37.598922531817, -36.280284096603, 0);
line(-37.598922531817, -36.280284096603, 0, -31.653023333528, -35.476366984093, 0);
line(-31.653023333528, -35.476366984093, 0, -26.215176611308, -32.940657413649, 0);
line(-26.215176611308, -32.940657413649, 0, -21.848540065365, -28.825747296084, 0);
line(-21.848540065365, -28.825747296084, 0, -19.087341356662, -23.498854985266, 0);
line(-19.087341356662, -23.498854985266, 0, -18.34573249622, -17.544863357953, 0);
line(-18.34573249622, -17.544863357953, 0, -19.817576811493, -11.728191258582, 0);
line(-19.817576811493, -11.728191258582, 0, -23.386513532001, -6.9050500948788, 0);
line(-23.386513532001, -6.9050500948788, 0, -28.572162343724, -3.8869304150978, 0);
line(-28.572162343724, -3.8869304150978, 0, -34.540379246427, -3.2701751943747, 0);
line(-34.540379246427, -3.2701751943747, 0, -40.199715194112, -5.2631419856773, 0);
line(-40.199715194112, -5.2631419856773, 0, -44.390206906698, -9.5572983879, 0);
line(-44.390206906698, -9.5572983879, 0, -46.144437135034, -15.295126923678, 0);
line(-46.144437135034, -15.295126923678, 0, -44.968760269578, -21.178814874958, 0);
line(-44.968760269578, -21.178814874958, 0, -41.064114965983, -25.734442718967, 0);
line(-41.064114965983, -25.734442718967, 0, -35.394421493038, -27.697750112841, 0);
line(-35.394421493038, -27.697750112841, 0, -29.529926127321, -26.429801334108, 0);
line(-29.529926127321, -26.429801334108, 0, -25.250423432396, -22.224345748309, 0);
line(-25.250423432396, -22.224345748309, 0, -23.982474653665, -16.359850382592, 0);
line(-23.982474653665, -16.359850382592, 0, -26.239820232501, -10.800678597361, 0);
line(-26.239820232501, -10.800678597361, 0, -31.294534614545, -7.5680538873205, 0);
line(-31.294534614545, -7.5680538873205, 0, -37.282028324178, -7.9552477368389, 0);
line(-37.282028324178, -7.9552477368389, 0, -41.810285805514, -11.891601910782, 0);
line(-41.810285805514, -11.891601910782, 0, -42.924285497827, -17.787278690044, 0);
line(-42.924285497827, -17.787278690044, 0, -40.052134350182, -23.055176542612, 0);
line(-40.052134350182, -23.055176542612, 0, -34.454413141229, -25.215157391331, 0);
line(-34.454413141229, -25.215157391331, 0, -28.823455004672, -23.14336819734, 0);
line(-28.823455004672, -23.14336819734, 0, -26.052963325263, -17.82130319827, 0);
	noStroke();
	if (alternateColors) {
		fill(180, 180, 180, 120);
	} else {
		fill(120, 120, 120, 180);
	}
	translate(0,0,-50);
	box(200,200,100);
	translate(0,0,50);
}
void mouseDragged() {
	middlex += mouseX - pmouseX;
	middley += mouseY - pmouseY;
}
void keyPressed() {
	if (keyCode == UP) {
		middlez += 15.0;
	}
	if (keyCode == DOWN) {
		middlez -= 15.0;
	}
	if (key == 'r' || key == 'R') {
		if (isRotating) {
			isRotating = false;
		} else {
			isRotating = true;
			if (!isRotatingX && !isRotatingY && !isRotatingZ) { isRotatingZ = true; }
		}
	}
	if (key == 'c' || key == 'C') {
		if (alternateColors) {
			alternateColors = false;
		} else {
			alternateColors = true;
		}
	}
	if (key == 'x' || key == 'X') {
		if (isRotatingX) {
			isRotatingX = false;
		} else {
			isRotatingX = true;
		}
	}
	if (key == 'y' || key == 'Y') {
		if (isRotatingY) {
			isRotatingY = false;
		} else {
			isRotatingY = true;
		}
	}
	if (key == 'z' || key == 'Z') {
		if (isRotatingZ) {
			isRotatingZ = false;
		} else {
			isRotatingZ = true;
		}
	}
}