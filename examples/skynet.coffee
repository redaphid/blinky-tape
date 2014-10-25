skynet = require('skynet')
_ = require('lodash')
BlinkyTape = require('../blinky-tape.coffee')

r = { red: 254, green: 0, blue: 0}
g = { red: 0, green: 254, blue: 0}
b = { red: 0, green: 0, blue: 254}
o = {red: 0, green: 0, blue: 0}

blinkyData = []



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
  blink.send(message.payload)
    

blink = new BlinkyTape('/dev/ttyACM0');

blink.send( [ r, g, b, r, g, b, b, r, g ] )