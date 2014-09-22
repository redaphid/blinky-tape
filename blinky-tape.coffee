SerialPort = require('serialport').SerialPort
w = require('when')

class BlinkyTape

	constructor : (@portName) ->
		defer = w.defer()
		this.connection = defer.promise

		errorHandler = (@error) =>
			console.error(error)
			defer.reject(error)

		serial = new SerialPort(@portName || '/dev/ttyACM0', baudrate: 115200)
		
		serial.on('error', errorHandler)
		serial.on('open', (@error) =>
			return errorHandler(error) if @error
			
			console.log('connected')
			defer.resolve(serial)
		)

	send: =>
		this.connection.then (@serial) =>
			console.log('hi')



b = new BlinkyTape();

b.send()