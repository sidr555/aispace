###
  Контроллер стенда с выходом по etherner
###

'use strict'

module.exports = {
  id: "Controller"
  title: "Контроллеры стендов"
  logging: yes

  sort: 7

  schema: {
    id: {
      type: "string"
      index: yes
      unique: yes
    }
    name: {
      type: "string"
    }
    idStand: {
      type: "number"
      index: yes
      title: "id стенда"
    }
    ip: {
      type: "string"
      index: yes
      title: "IP адрес"
    }
    port: {
      type: "number"
      title: "Порт"
    }
    lastPointTime: {
      type: "date"
      title: "Время обновления пойнтов"
    }
    points: {
      type: "json"
      title: "Поинты"
      template: "controller/points-link"
    }
  }
  deps: {
    hasMany: {
      Point: {
        as: "points",
        foreignKey: "idController"
        title: "Входы и выходы"
      }
    },
    belongsTo: {
      Stand: {
        as: 'stand',
        foreignKey: 'idStand'
        title: 'Находится на стенде'
      }
    }
  }
}

module.exports.init = (model) ->

  model.prototype.isPointListActual = ->  
    if @lastPointTime
      now = new Date()
      if now.getTime() - @lastPointTime.getTime() <= 60 * 1000
        return yes
    return no


  model.prototype.getPoints = (next) ->

    if 1
      fs = require "fs"
      fs.readFile "/home/sidr/dev/ai/aispace/points.json", (err, data) ->
        if err then next err
        else
          #console.log "Data in points.json", data

          try
            points = JSON.parse data
            next null, points

          catch err
            console.error err
            next err  

    else

      http = require "http"

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
      

  model.prototype.set = (slave, port) ->
    console.log "TURN CELL ON", @id

#
#  model.prototype.turnOff = ->
#    console.log "TURN CELL OFF", @id
#
