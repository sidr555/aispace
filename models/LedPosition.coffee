###
  Отрезок на светодиодной ленте, который относится к товару
###

'use strict'

module.exports = {
  id: "LedPosition"
  #dbKey: "led-pos"
  title: "Подсветка товаров"
  #logging: yes

  hide: yes

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    idLine: {
      type: "number"
      index: yes
      title: "id светодиодной ленты"
    }
    idStuff: {
      type: "number"
      index: yes
      title: "id товара"
    }
    offset: {
      type: "number"
      title: "отступ от начала ленты"
      default: 0
    }
    width: {
      type: "number"
      title: "ширина отрезка"
      default: 1
    }
    createDate: {
      type: "date"
      default: Date.now
      title: "Дата добавления"
    }
  }
  deps: {
    belongsTo: {
      LedLine: {
        as: 'ledline',
        foreignKey: 'idLine'
        title: 'Находится на светодиодной ленте'
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
    console.log "led line position #{id} is turned on!"
    do next if next?

  model.prototype.turnOff = (next) ->
    console.log "led line position #{id} is turned off!"
    do next if next?