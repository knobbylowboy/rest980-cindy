var express = require('express');
var router = express.Router();

var helloResponse = {
  documentation: 'https://github.com/koalazak/rest980'
};

router.use(express.json());

router.get('/', function (req, res) {
  res.render('controls', { title: 'Roomba Controls' });
});

router.get('/ping', function (req, res) {
  helloResponse.pong = new Date();
  res.send(helloResponse);
});

module.exports = router;
