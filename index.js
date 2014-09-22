// Generated by CoffeeScript 1.8.0
(function() {
  var BlinkyTape, PSerial, SerialPort, ledCount, resetPosition, rgbToBuffer, w, wNode, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SerialPort = require('serialport').SerialPort;

  w = require('when');

  wNode = require('when/node');

  _ = require('lodash');

  ledCount = 60;

  resetPosition = new Buffer([0x0, 0x0, 0xFF]);

  rgbToBuffer = (function(_this) {
    return function(rgbList) {
      var i, rgb, rgbBuffer, _i, _ref;
      rgbBuffer = new Buffer(rgbList.length * 3);
      for (i = _i = 0, _ref = rgbList.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        rgb = rgbList[i];
        rgbBuffer[i * 3] = rgb.red;
        rgbBuffer[i * 3 + 1] = rgb.green;
        rgbBuffer[i * 3 + 2] = rgb.blue;
      }
      return rgbBuffer;
    };
  })(this);

  BlinkyTape = (function() {
    function BlinkyTape(portName) {
      this.animate = __bind(this.animate, this);
      this.send = __bind(this.send, this);
      var defer, errorHandler, serial;
      defer = w.defer();
      this.connection = defer.promise;
      errorHandler = (function(_this) {
        return function(error) {
          console.error(error);
          return defer.reject(error);
        };
      })(this);
      serial = new SerialPort(portName || '/dev/ttyACM0', {
        baudrate: 115200
      });
      serial.on('error', errorHandler);
      serial.on('open', (function(_this) {
        return function(error) {
          if (error) {
            return errorHandler(error);
          }
          console.log('connected');
          return defer.resolve(new PSerial(serial));
        };
      })(this));
    }

    BlinkyTape.prototype.send = function(rgbList) {
      return this.connection.then((function(_this) {
        return function(pserial) {
          var b;
          b = rgbToBuffer(rgbList);
          return pserial.write(b).then(pserial.write(resetPosition)).then(pserial.drain)["catch"](function(error) {
            return console.error('ERROR', error);
          }).then(function() {
            return _this;
          });
        };
      })(this));
    };

    BlinkyTape.prototype.animate = function(frames, ms) {
      return w.iterate((function(_this) {
        return function(i) {
          i = i % frames.length;
          return _this.send(frames[i]).then(function() {
            return i + 1;
          });
        };
      })(this), (function(_this) {
        return function() {
          return false;
        };
      })(this), (function(_this) {
        return function(i) {
          return w().delay(ms);
        };
      })(this), 0).done();
    };

    return BlinkyTape;

  })();

  PSerial = (function() {
    function PSerial(serial) {
      this.serial = serial;
      this.drain = __bind(this.drain, this);
      this.write = __bind(this.write, this);
    }

    PSerial.prototype.write = function(buffer) {
      return w.promise((function(_this) {
        return function(resolve, reject) {
          return _this.serial.write(buffer, function(error) {
            if (error) {
              reject(error);
            }
            return resolve();
          });
        };
      })(this));
    };

    PSerial.prototype.drain = function() {
      return w.promise((function(_this) {
        return function(resolve, reject) {
          return _this.serial.drain(function(error) {
            if (error) {
              reject(error);
            }
            return resolve();
          });
        };
      })(this));
    };

    return PSerial;

  })();

  module.exports = BlinkyTape;

}).call(this);
