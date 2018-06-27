###
  Товар наделенный характеристиками
###

'use strict'
#mur3 = require "node-murmur3"

module.exports = {
  id: "Stuff"
  title: "Товары"
  logging: yes

  sort: 22

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    name: {
      type: "string"
      limit: 200
      index: yes
      title: "название товара"
      hint: "может включать макросы, например, 'Тапочки зимние {brand.name}, {feature.color}'"
    }
    idParent: {
      type: "number"
      index: yes
      default: null
      title: "id товара-образца"
    }
#    fixedFeatures: {  # не давать менять характеристики админам
#      type: "boolean"
#      index: yes
#      default: yes
#      title: "Фиксированные характеристики"
#    }
    idShop: {
      type: "number"
      index: yes
      default: null # если магазин не указан, товар является родительским для подобных товаров по магазинам и служит для хранения информации и обобщенных характеристик
      title: "id магазина"
    }
#    idStand: {
#      type: "number"
#      index: yes
#      default: null # витрина, на которой находится товар
#      title: "id витрины"
#    }
    idCat: {  # Катеория товаров
      type: "number"
      index: yes
      title: "id категории товара"
    }
    featureConfig: {
      type: "json"
      title: "Настройки характеристик"
      #template: "stuff/feature_list"
    }
  }
  deps: {
    belongsTo: {
      Shop: {
        as: 'shop',
        foreignKey: 'idShop'
        title: 'Находится в магазине'
      }
#      Stand: {
#        as: 'stand',
#        foreignKey: 'idStand'
#        title: 'Находится на витрине'
#      }
      Category: {
        as: 'category',
        foreignKey: 'idCategory'
        title: 'Состоит в группе товаров'
      }
    }
    hasMany: {
      Cell: {
        as: 'cells',
        foreignKey: 'idStuff'
        title: 'Находится в ячейках'
      }
#      StuffValue: {
#        as: 'values'
#        foreignKey: 'idStuff'
#        title: 'Значения характеристик'
#      }
#      Feature: {
#        as: 'features'
#        foreignKey: 'idStuff'
#        title: 'Характеристики'
#      }

#      StandInput: {
#        as: 'inputs'
#        foreignKey: 'idStuff'
#        title: 'Кнопки на витрине'
#      }
#      StandOutput: {
#        as: 'outputs'
#        foreignKey: 'idStuff'
#        title: 'Активаторы на витрине'
#      }
#      LedPosition: {
#        as: 'ledlines'
#        foreignKey: 'idStuff'
#        title: 'Светодиодная подсветка'
#      }
    }
#    includesList: {
#      featureConfig: {
#        template: "../stuff/feature_list"
#      }
#    }
  }
}


module.exports.init = (model) ->
  model.prototype.getJson = ->
#console.log "get JSON of cell #{@id}"
    {
      id: @id
      name: @name
    }

