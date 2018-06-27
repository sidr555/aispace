###
  Цифровой вход на витрине (кнопка)
###

'use strict'

module.exports = {
  id: "StandOutput"
  dbKey: "output"
  title: "Активаторы на стенде"
  logging: yes

  hide: yes

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    idStand: {
      type: "number"
      index: yes
      title: "id стенда"
    }
    idStuff: {
      type: "number"
      index: yes
      default: null
      title: "Привязанный к кнопке товар"
    }
  }
  deps: {
    belongsTo: {
      Stand: {
        as: 'stand',
        foreignKey: 'idStand'
        title: 'Находится на витрине'
      }
      Stuff: {
        as: 'stuff',
        foreignKey: 'idStuff'
        title: 'Относится к товару'
      }
    }
  }
}

module.exports.init = (model) ->
  model.prototype.turnOn = (next) ->
    console.log "output #{@id} is turned on!"
    do next if next?

  model.prototype.turnOff = (next) ->
    console.log "output #{@id} is turned off!"
    do next if next?