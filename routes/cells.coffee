express = require 'express'
router = express.Router()

#Cell = (require '../models') 'Cell'
_ = require "underscore"

router.get '/:id/stuff', (req, res, next) ->
  req.models.Cell.findById req.params.id, (err, cell) ->
    if err
      next err
    else unless cell
      next {status: 404}
    else 
      console.log "CELL", cell
      #if cell.idStuff
      cell.stuff (err, stuff) -> 
        console.log "Stuff in the cell", stuff

        req.models.Stuff.all {order: 'name'}, (err, allStuff) ->
          res.render "cell/stuff-view", {
            cell: cell
            stuff: stuff
            allStuff: allStuff
          }


router.get '/:id/turnOn', (req, res, next) ->
  req.models.Cell.findById req.params.id, (err, cell) ->
    if err
      next err
    else unless cell
      next {status: 404}
    else
      do cell.turnOn
      res.send "OK"

router.get '/:id/turnOff', (req, res, next) ->
  req.models.Cell.findById req.params.id, (err, cell) ->
    if err
      next err
    else unless cell
      next {status: 404}
    else
      do cell.turnOff
      res.send "OK"

module.exports = router;
