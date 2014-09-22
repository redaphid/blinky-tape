SerialPort = require('serialport').SerialPort
w = require('when')
wNode = require('when/node')
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
		@ledData = []
		
		for i in [1..60]
			@ledData.push({ red: 255, green: 255, blue: 255 })

		defer = w.defer()
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

		 	console.log('made it')
		 	b = rgbToBuffer(rgbList)

		 	pserial.write(b)
		 		.then(pserial.write(resetPosition))
				.then(pserial.drain)
				.catch((error) => console.error('ERROR', error))



class PSerial
	constructor: (@serial) ->

	write : (buffer) =>
		w.promise( (resolve, reject) =>
			@serial.write(buffer, (error) =>
				console.log('written ' + buffer.length)
				reject(error) if error
				resolve()
			)
		)

	drain : =>
		w.promise( (resolve, reject) =>
			@serial.drain((error) =>
				console.log('drain');
				reject(error) if error
				resolve()
			)
		)


red = { red: 254, green: 0, blue: 0}
green = { red: 0, green: 254, blue: 0}
blue = { red: 0, green: 0, blue: 254}

b = new BlinkyTape();

b.send([red, green, red, blue, blue])
	.delay(100)
	.then( => b.send([blue, blue, blue, blue]))
	.delay(100)
	.then( => b.send([red, red, red, red, red]))
