###
  Контроллер ячеек со связью с мастером по 1-wire
###

'use strict'

module.exports = {
  id: "Point"
  title: "Входы и выходы в ячейках"
  logging: yes

  sort: 15

  schema: {
    id: {
      type: "string"
      index: yes
      unique: yes
      title: "uid"
    }
    # name: {
    #   type: "string"
    # }
    # isInput: {
    #   type: "boolean"
    #   index: on
    #   title: "является входом"
    # }
    state: {
      type: "number"
      title: "состояние портов (вкл|выкл)"
    }
    stateTime: {
      type: "date"
      title: "время обновления состояния"
    }
    idController: {
      type: "number"
      index: on
      title: "id контроллера"
    }
    # idCell: {
    #   type: "string"
    #   index: on
    #   title: "id ячейки"
    # }
  }
  deps: {
    belongsTo: {
      Controller: {
        as: 'controller',
        foreignKey: 'idController'
        title: 'подключен к контроллеру'
      }
      # Cell: {
      #   as: 'cell',
      #   foreignKey: 'idCell'
      #   title: 'обслуживает ячейку'
      # }
    }
  }
}

module.exports.init = (model) ->
  model.prototype.getState = (next) ->
    console.log "Get Point state", @id
    # @master (err, master) ->
    #   if err
    #     next err if next?
    #   else
    #     master.set id, port


  model.prototype.turnOn = (port, next) ->
    console.log "TURN Stand Point ON", @id
    @master (err, master) ->
      if err
        next err if next?
      else
        master.set id, port

  model.prototype.turnOff = (port) ->
    console.log "TURN Stand Point OFF", @id
    @master (err, master) ->
      if err
        next err if next?
      else
        master.set id, port

