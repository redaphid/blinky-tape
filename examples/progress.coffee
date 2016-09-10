_ = require 'lodash'
BlinkyTape = require '../blinky-tape.coffee'
blink = new BlinkyTape {port: '/dev/ttyACM0', ledCount: 50}

number = 0

incrementProgress = ->
	blink.updateColor {number, color: 'yellow'}
	number++

blink.connect (error) ->
	blink.sync ->
		setInterval incrementProgress, 500
