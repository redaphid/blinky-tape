skynet = require('skynet')
_ = require('lodash')
BlinkyTape = require('../blinky-tape.coffee')

ledCount = 60

r = { red: 254, green: 0, blue: 0}
g = { red: 0, green: 254, blue: 0}
b = { red: 0, green: 0, blue: 254}
o = {red: 0, green: 0, blue: 0}

blinkyData = []
_.times(60, =>
    blinkyData.push(o)
  )



uuid = '128df951-5c79-11e4-9bc0-f3669132c3b6'
token = '0j9nrktzyali8uxrpj9exg0kn6z5b3xr'

skynet = require("skynet")
conn = skynet.createConnection(
  uuid: uuid
  token: token
)

conn.on "ready", (data) ->
  console.log "UUID AUTHENTICATED!"
  console.log data

conn.on "message", (message) ->
  try
    console.log('MESSAGE!!')
    console.log(message)
    blinkyData = message.payload.concat( _.rest(blinkyData, message.payload.length))
    blinkyData.length = ledCount unless blinkyData.length < ledCount
    blink.send(blinkyData)
  catch error

    console.log("Error! #{error}")
    

blink = new BlinkyTape('/dev/ttyACM0');

blink.send( blinkyData )