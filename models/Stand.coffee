###
  Витрина (стенд)
###

'use strict'

module.exports = {
  id: "Stand"
  title: "Стенды"
  logging: yes

  sort: 6

#  types: {
#    board: "В одну линию"
#    table: "Несколько полок"
#    custom: "Другая схема"
#  }

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    name: {
      type: "string"
      index: yes
      default: "Витрина"
      title: "Название"
    }
    idShop: {
      type: "number"
      index: yes
      title: "id магазина"
    }
    active: {
      type: "boolean"
      default: true
      #index: yes
    }
    activateDate: {
      type: "date"
      default: Date.now
      title: "Дата добавления"
    }
    layout: {
      type: "json"
#      default: {
#        rows: 1
#        cols: 1
#      }
      title: "Схема"
      template: "stand/layout"
    }
  }

  deps: {
    belongsTo: {
      Shop: {
        as: 'shop',
        foreignKey: 'idShop'
        title: 'Находится в магазине'
      }
    }
    hasMany: {
      Cell: {
        as: 'cells'
        foreignKey: "idStand"
        title: "Позиции товаров (ячейки)"
      }
#      Stuff: {
#        as: 'stuffs'
#        foreignKey: 'idStand'
#        title: 'Товары на витрине'
#      }
#      StandInput: {
#        as: 'inputs'
#        foreignKey: 'idStand'
#        title: 'Входы (кнопки)'
#      }
#      StandOutput: {
#        as: 'outputs'
#        foreignKey: 'idStand'
#        title: 'Выходы (активаторы)'
#      }
#      LedLine: {
#        as: 'ledlines'
#        foreignKey: 'idStand'
#        title: 'Свктодиодные линии'
#      }

    }
  }
}
