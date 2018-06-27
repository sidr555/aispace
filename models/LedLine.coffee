###
  Светодиодная лента на стендe
###

'use strict'

module.exports = {
  id: "LedLine"
  title: "Светодиодные линии"
  logging: yes

  hide: yes

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    idShop: {
      type: "number"
      index: yes
      title: "id Магазина"
    }
    active: {
      type: "boolean"
      default: yes
      index: yes
    }
    createDate: {
      type: "date"
      default: Date.now
      title: "Дата добавления"
    }
  }
  deps: {
    belongsTo: {
      Stand: {
        as: 'stand',
        foreignKey: 'idStand'
        title: 'Находится на витрине'
      }
    }
  }
}

module.exports.init = (model) ->
  model.prototype.turnOn = (next) ->
    console.log "output is turned on!"
    do next if next?