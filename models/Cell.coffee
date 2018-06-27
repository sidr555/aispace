###
  Ячейка товара на стенде
###

'use strict'

md5 = require "md5"

module.exports = {
  id: "Cell"
  title: "Ячейки с товарами"
  logging: yes

  sort: 10

  schema: {
    id: {
      type: "string"
      index: yes
      unique: yes
    }
    idStand: {
      type: "number"
      index: yes
      title: "id стенда"
    }
    idController: {
      type: "number"
      index: yes
      title: "Контроллер"
    }
    idStuff: {
      type: "number"
      index: yes
      title: "Товар"
    }
    row: {
      type: "number"
      title: "номер полки"
      default: 0
    }
    index: {
      type: "number"
      title: "номер на полке"
      default: 0
    }
    width: {
      type: "number"
      title: "Ширина ячейки"
      default: 1
    }
#    createDate: {
#      type: "date"
#      default: Date.now
#      title: "Дата добавления"
#    }
  }
  deps: {
    belongsTo: {
      Stand: {
        as: 'stand',
        foreignKey: 'idStand'
        title: 'Находится на стенде'
      }
      Stuff: {
        as: 'stuff',
        foreignKey: 'idStuff'
        title: 'Содержит товар'
      }
    }
    hasMany: {
      PointPort: {
        as: 'ports',
        foreignKey: 'idCell'
        title: 'Входы и выходы'
      }
    }
  }
}

module.exports.init = (model) ->
#  model.beforeCreate = (next) ->
#    now = new Date()
#    @id = md5("" + now.getTime() + @idStand + @row) unless @id
#    @createDate = now unless @createDate
#    do next
#
#  model.prototype.getJson = ->
#    #console.log "get JSON of cell #{@id}"
#    {
#      id: @id
#      row: @row
#      width: @width
#    }

  model.prototype.turnOn = (next) ->
    if @idController
      console.log "TURN CELL ON", @id
      @controller (err, controller) =>
        if err
          next err if next?
        else
          controller.turnOn @port
          #console.log "controller", a, b
    else
      console.log "No controller for this cell"

  model.prototype.turnOff = (next) ->
    if @idController
      @controller (err, controller) =>
        if err
          next err if next?
        else
          controller.turnOff @port
      #console.log "TURN CELL OFF", @id
      #console.log "Controller", @controller()
    else
      console.log "No controller for this cell"


