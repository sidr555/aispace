express = require 'express'
router = express.Router()

Stand = (require '../models') 'Stand'
_ = require "underscore"
async = require "async"


router.get '/:id/cells', (req, res, next) ->
  req.models.Stand.findById req.params.id, (err, stand) ->
    if err
      next err
    else unless stand
      next {status: 404}
    else
      stand.cells (err, cells) ->
        if err
          next err
        #console.log "CELLS", cells
        res.json cells


router.get '/:id/layout', (req, res, next) ->
#console.log req.models.Stand
  req.models.Stand.findById req.params.id, (err, stand) ->
    if err
      next err
    else unless stand
      next {status: 404}
    else
      #console.log stand
      res.render "stand/layout-edit", {
        id: stand.id
        #layout: stand.layout
        #cells: cellsData
      }

      return

#      cellsData = []
#      fns = []
#
#      stand.cells (err, cells) ->
#        _.each cells, (cell, index) ->
#          cellJson = cell.getJson()
#          fns.push (((cell, cellJson, cellsData) ->
#            (next) ->
#              if cell.idStuff > 0
#                cell.stuff (err, stuff) ->
#                  cellJson.Stuff = stuff.getJson()
#                  cellsData.push cellJson
#                  console.log "loaded stuff in cell", cellJson.id
#                  do next
#              else
#                console.log "no stuff in cell", cellJson.id
#                cellsData.push cellJson
#                do next
#          ) cell, cellJson, cellsData)
#
#
#        console.log fns.length, fns
#
#        async.parallel fns, (err, data) ->
#          #console.log "async", err, data
#          #console.log "async cd", JSON.stringify(cellsData[1])
#          console.log "async cd", cellsData
#          res.render "stand/layout-edit", {
#            id: stand.id
#            #layout: stand.layout
#            cells: cellsData
#          }
#


router.get '/:id/view', (req, res, next) ->
  req.models.Stand.findById req.params.id, (err, stand) ->
    if err
      next err
    else unless stand
      next {status: 404}
    else
      console.log stand

      stand.cells (err, cells) ->
        if err
          next err
        else
          maxRow = 0
          rows = {}
          stuffPromises = []

          _.each cells, (cell) ->
            #console.log "reduce", ids, cell

            maxRow = cell.row if maxRow < cell.row
            unless rows[cell.row]?
              rows[cell.row] = {
                id: cell.row
                width: 0
                cells: []
              }

            rows[cell.row].width += cell.width
            rows[cell.row].cells.push cell

            if cell.idStuff
              console.log "STUFF", cell.idStuff, cell.stuff(cell.idStuff)
              stuffPromises.push ((cell) ->
                new Promise (resolve, reject) ->
                  req.models.Stuff.findById cell.idStuff, (err, stuff) ->
                    if err
                      reject err
                    else
                      resolve stuff
              )(cell)

#            ids.push cell.idStuff if cell.idStuff

          Promise.all stuffPromises
          .then (arr) ->
#            _.each @config, (cellConfig) ->
#              cell = new Cell cellConfig
#              idRow = cell.config.row
#              maxRow = idRow if idRow > maxRow
#
#              if rowCells[idRow]?
#                rowCells[idRow].push cell
#              else
#                rowCells[idRow] = [cell]
#
#            for idRow in [0..maxRow]
#              row = new Row idRow, rowCells[idRow].sort (a,b) -> if a.index < b.index then -1 else 1
#              do row.build
#              @el.append row.el
#              @rows.push row


            stuffs = arr.reduce (obj, stuff) ->
              obj[stuff.id] = stuff.toJSON()
              obj
            , {}

            _.each rows, (row) ->
              row.cells = row.cells.sort (a, b) -> if a.index < b.index then -1 else 1
              _.each row.cells, (cell) ->
                cell.col = 5 * parseInt(20 * cell.width / row.width)
                if cell.idStuff and stuffs[cell.idStuff]
                  cell.stuff = stuffs[cell.idStuff]

                  #console.log "ROWs", rows


            res.render "stand/layout-view", {
              stand: stand
              cells: cells
              rows: rows
              maxRow: maxRow
              stuffs: stuffs
            }

          .catch (err) ->
            next err



router.get '/:id/edit', (req, res, next) ->
  #console.log req.models.Stand
  req.models.Stand.findById req.params.id, (err, stand) ->
    if err
      next err
    else unless stand
      next {status: 404}
    else
      console.log stand

      res.render "stand/layout-edit", {
        id: stand.id
        layout: stand.layout
      }

      #res.json stand


#  Shop.findById {where: {id: req.params.id}}, (err, shop) ->
#    console.log "get shop id = ", req.params.id
#    Shop.findById req.params.id, (err, data) ->
#      if err
#        res.json {error: err.message}
#      else
#        console.log "shop", data, data.owner
#
##        data.owner (err, user) ->
##          if err
##            res.json {error: err.message}
##          else
##            console.log "owner", user
##            data.user = user
#        res.json data
#

router.post '/:id/set_layout', (req, res, next) ->
  #console.log req.models.Stand
  Stand = req.models.Stand
  Cell = req.models.Cell

  Stand.findById req.params.id, (err, stand) ->
    if err
      next err
    else unless stand
      next {status: 404}
    else
      console.log "Save stand", req.params.id, stand

      #console.log "Data", req.body.cells

      #stand.layout = JSON.parse req.body.layout
      #stand.layout = req.body.layout
      cells = JSON.parse req.body.cells
      console.log "Save CELLS", cells
      promises = []
      if cells and cells.length
        _.each cells, (cell) ->
          promises.push ((cell) ->
            new Promise (resolve, reject) ->
              if cell.deleted
                console.log "delete cell"
                unless cell.created
                  Cell.remove {where: {id: cell.id}}, (err) ->
                    if err then reject err
                    else do resolve

              else if cell.created
                cell.id = null
                cell.created = null
                cell.idStand = parseInt req.params.id
                Cell.create cell, (err, data) ->
                  if err then reject err
                  else resolve data
              else
                Cell.create cell, (err, data) ->
                  if err then reject err
                  else resolve data
          )(cell)

      Promise.all promises
      .then (results) ->
        console.log "ALL CELLS ARE SAVED", results
        res.send "OK"
      .catch (err) ->
        next err


#      return
#      console.log "new layout", stand
#
#      #return res.json stand
#
#      req.models.Stand.create stand, (err) ->
#        if err
#          console.log "update error", err
#          next err
#        else
#          console.log "Stand is updated"
#          Stand.findById req.params.id, (err, data) ->
#            if err
#              next err
#            else unless data
#              next {status: 404}
#            else
#              console.log "Save stand at last", req.params.id, data
#              res.send "OK"
#
#
#      return
#
#
#      #return           res.send "OK"


module.exports = router;
