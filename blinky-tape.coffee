{SerialPort} = require('serialport')
When = require('when')
_ = require('lodash')

ledCount = 60
resetPosition = new Buffer([0x0, 0x0, 0xFF])

rgbToBuffer = (rgbList) =>
	rgbBuffer = new Buffer(rgbList.length * 3)
	for i in [0..rgbList.length - 1]
		rgb = rgbList[i]
		rgbBuffer[i * 3] = rgb.red
		rgbBuffer[i * 3 + 1] = rgb.green
		rgbBuffer[i * 3 + 2] = rgb.blue

	return rgbBuffer


class BlinkyTape

	constructor : (portName) ->
		defer = When.defer()		
		@connection = defer.promise

		errorHandler = (error) =>
			console.error(error)
			defer.reject(error)

		serial = new SerialPort(portName || '/dev/ttyACM0', baudrate: 115200)
		
		serial.on('error', errorHandler)
		serial.on('open', (error) =>
			return errorHandler(error) if error
			
			console.log('connected')
			defer.resolve( new PSerial(serial))
		)

	send: (rgbList) =>
		@connection.then (pserial) =>			
		 	b = rgbToBuffer(rgbList)

		 	pserial.write(b)
		 		.then(pserial.write(resetPosition))
				.then(pserial.drain)
				.catch((error) => console.error('ERROR', error))
				.then( => return this)

	animate: (frames, ms) =>
		When.iterate(
			(i) =>
				i = i % frames.length
				this.send( frames[i] ).then( => return i + 1)
			, 
			=> false, 
			(i) => When().delay(ms),
			0
		).done()



class PSerial
	constructor: (@serial) ->

	write : (buffer) =>
		When.promise( (resolve, reject) =>
			@serial.write(buffer, (error) =>
				reject(error) if error
				resolve()
			)
		)

	drain : =>
		When.promise( (resolve, reject) =>
			@serial.drain((error) =>
				reject(error) if error
				resolve()
			)
		)

module.exports = BlinkyTape