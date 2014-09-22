BlinkyTape = require('../blinky-tape.coffee')
r = { red: 254, green: 0, blue: 0}
g = { red: 0, green: 254, blue: 0}
b = { red: 0, green: 0, blue: 254}
o = {red: 0, green: 0, blue: 0}
ms = 100

blink = new BlinkyTape('/dev/ttyACM1');

blink.animate([
	[r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r]
	[b,r,r,r,r]
	[r,b,r,r,r]
	[r,r,b,r,r]
	[r,r,r,b,r]
	[r,r,r,r,b]
	[r,r,r,b,r]
	[r,r,b,r,r]
	[r,b,r,r,r]
	[b,r,r,r,r]
	[r,r,r,r,r]
	[r,r,r,r,r]
	[r,r,r,r,r]
], 100);