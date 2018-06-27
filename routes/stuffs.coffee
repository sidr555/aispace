express = require 'express'
router = express.Router()

_ = require "underscore"
async = require "async"


router.get '/:id/get', (req, res, next) ->
#console.log req.models.Stand
  req.models.Stuff.findById req.params.id, (err, stuff) ->
    if err
      next err
    else unless stuff
      next {status: 404}
    else
      res.json stuff


module.exports = router;
