express = require 'express'
router = express.Router()

http = require "http"
_ = require "underscore"


router.get '/:id/points', (req, res, next) ->
  req.models.Controller.findById req.params.id, (err, controller) ->
    if err
      next err
    else unless controller
      next {status: 404}
    else
      controller.points (err, points) ->
        if err
          console.error err
          next err
        else

          console.log "lastPointTime", controller.lastPointTime.getTime(),  controller.isPointListActual()

          if points.length && controller.isPointListActual()
            console.log "db points", points, controller.lastPointTime
            res.render "controller/points-view", {points: points} 
          else

            if 1
              fs = require "fs"
              fs.readFile "/home/sidr/dev/ai/aispace/points.json", (err, data) ->
                if err then next err
                else
                  #console.log "Data in points.json", data

                  try
                    loadedPoints = JSON.parse data
                    points = []

                    req.models.Controller.update {id: controller.id}, {lastPointTime: new Date()}
                    controller.points.remove {where: {idController: controller.id}}, (err) ->

                      now = new Date()
                      _(loadedPoints).each (point) ->
                        console.log "POINT", point, parseInt(point.state, 16)

                        pointData = {
                          id: point.uid
                          state: parseInt point.state, 16
                          stateTime: now
                          idController: controller.id
                        }

                        controller.points.create pointData
                        points.push pointData

                      console.log "loaded points", points, controller.lastPointTime
                      res.render "controller/points-view", {points: points} 

                  catch err
                    console.error err
                    next err  

            else
              options = {
                host: @ip
                port: 80
                path: '/points.json'
                method: 'GET'
              }

              console.log "getPoints by", options

              req = http.request options, (res) ->
                #console.log 'STATUS: ' + res.statusCode
                #console.log 'HEADERS: ' + JSON.stringify(res.headers)
                res.setEncoding 'utf8'
                res.on 'data', (chunk) ->
                  console.log('BODY: ' + chunk);
                  try
                    points = JSON.parse chunk
                    next null, points

                  catch err
                    console.error err
                    next err  
                  
                req.on 'error', (err) ->
                  console.log 'problem with request: ' + err.message
                  next err

              req.end()



      # controller.getPoints (err, points) ->
      #   if err
      #     console.error err
      #     next err

      #   console.log "POINTS", err, points
      #   res.render "controller/points-view", {points: points}
      #   #res.send points



module.exports = router;
