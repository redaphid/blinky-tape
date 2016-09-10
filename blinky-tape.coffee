_          = require 'lodash'
debug 		 = require('debug')('blinky-tape')
SerialPort = require 'serialport'
tinycolor  = require 'tinycolor2'

DEFAULT_LED_COUNT = 50
DEFAULT_PORT			= '/dev/ttyACM0'
RESET_POSITION    = new Buffer([0x0, 0x0, 0xFF])

class BlinkyTape
	constructor: ({@port, @ledCount, @ledStates}={}) ->
		@port      ?= DEFAULT_PORT
		@ledCount  ?= DEFAULT_LED_COUNT
		@ledStates ?= _.fill Array(@ledCount), 'blue'

	close: (callback=->) =>
		return callback() unless @serial?
		@serial.close callback
		
	connect: (callback=->) =>
		debug "connecting to #{@port}"
		@serial = new SerialPort @port, baudrate: 115200
		@serial.on 'open', (error) =>
			debug "opened port. Error:", error
			callback error

	updateColor: ({number, color}, callback=->) =>
		@ledStates[number] = color
		@sync()

	sync: (callback=->) =>
		debug 'sync'
		rgbBuffer = new Buffer @ledCount * 3
		_.each @ledStates, (color, i) =>

			{r,g,b} = tinycolor(color).toRgb()
			r = 254 if r > 254
			g = 254 if g > 254
			b = 254 if b > 254
			rgbBuffer[i * 3] = r
			rgbBuffer[i * 3 + 1] = g
			rgbBuffer[i * 3 + 2] = b

		debug "writing:", rgbBuffer.toString 'hex'

		@serial.write Buffer.concat([rgbBuffer, RESET_POSITION]), (error) =>
			debug "finished writing:", error
			@serial.flush callback

module.exports = BlinkyTape
