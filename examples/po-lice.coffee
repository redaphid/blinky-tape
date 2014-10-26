BlinkyTape = require('../blinky-tape.coffee')
r = { red: 254, green: 0, blue: 0}
g = { red: 0, green: 254, blue: 0}
b = { red: 0, green: 0, blue: 254}
o = {red: 0, green: 0, blue: 0}
ms = 100
blink = new BlinkyTape('/dev/ttyACM0');

blink.animate([
	[r,g,b,r,r,g,b,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r]	
	[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b]
], ms);