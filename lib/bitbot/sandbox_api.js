require('coffee-script');
var SimpleResponder = require('../../../lib/bitbot/base_responders/simple_responder');
var log = require('../../../lib/bitbot/logger');

exports.api = {
  Bitbot: {
    SimpleResponder: SimpleResponder,
    log: log
  }
};
