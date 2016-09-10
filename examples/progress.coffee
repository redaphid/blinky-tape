_ = require 'lodash'
tinycolor = require 'tinycolor2'
BlinkyTape = require '../blinky-tape.coffee'
blink = new BlinkyTape {port: '/dev/ttyACM0', ledCount: 50}

number = 0
color = 'yellow'
direction = 1

incrementProgress = ->
	console.log {number, direction, color}
	blink.updateColor {number, color}
	number+=direction

	if number > 49
		direction = -1
		color = tinycolor.random()

	if number < 0
		direction = 1
		color = tinycolor.random()

blink.connect (error) ->
	blink.sync ->
		setInterval incrementProgress, 10
