SerialPort = require('serialport').SerialPort
w = require('when')
wNode = require('when/node')
_ = require('lodash')

ledCount = 60
resetPosition = new Buffer([0x0, 0x0, 0xFF])

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

	send: =>
		@connection.then (pserial) =>
			pserial.write(resetPosition)
				.then(pserial.drain)
				.then( =>
				 	console.log('made it')
				 	b = new Buffer(30)
				 	for i in [0..29]
				 		b[i] = i % 2 * 200

				 	pserial.write(b)
			 	)
			 	.then(pserial.drain)
			 	.catch((error) =>
			 		console.error('ERROR', error)
		 		)


b = new BlinkyTape();
b.send()

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