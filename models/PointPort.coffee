###
  Контроллер ячеек со связью с мастером по 1-wire
###

'use strict'

module.exports = {
  id: "PointPort"
  title: "Порты оконечных устройств"
  logging: yes

  sort: 16

  schema: {
    id: {
      type: "string"
      index: yes
      unique: yes
      title: "id порта"
    }
    idPoint: {
      type: "string"
      index: yes
      title: "id оконечного устройства"
    }
    bitmask: {
       type: "number"
       title: "битовая маска"
       default: 1
    }
    isInput: {
       type: "boolean"
       index: on
       title: "является входом?"
       default: no
    }
    state: {
      type: "boolean"
      title: "состояние порта"
    }
    stateTime: {
      type: "date"
      title: "время обновления состояния"
    }
    idCell: {
      type: "string"
      index: on
      title: "id ячейки"
    }
  }
  deps: {
    belongsTo: {
      Point: {
        as: "point"
        foreignKey: 'idPoint'
        title: 'оконечное устройство'
      }
      Cell: {
        as: 'cell'
        foreignKey: 'idCell'
        title: 'обслуживает ячейку'
      }
    }
  }
}

module.exports.init = (model) ->
  model.prototype.getTitle = ->
    @idPoint + " / " + @bitmask


# module.exports.init = (model) ->
#   model.prototype.turnOn = (port, next) ->
#     console.log "TURN Stand Point ON", @id
#     @master (err, master) ->
#       if err
#         next err if next?
#       else
#         master.set id, port

#   model.prototype.turnOff = (port) ->
#     console.log "TURN Stand Point OFF", @id
#     @master (err, master) ->
#       if err
#         next err if next?
#       else
#         master.set id, port

