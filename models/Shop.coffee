'use strict'

module.exports = {
  id: "Shop"
  title: "Магазины"
  logging: yes

  sort: 5

  schema: {
    id: {
      type: "number"
      index: yes,
      unique: yes
    }
    name: {
      type: "string"
      limit: 100
      index: yes
      title: "Название"
    }
    info: {
      type: "text"
      title: "Информация"
    }
    address: {
      type: "string"
      limit: 300
      title: "Адрес"
    },
    rating: {
      type: "number"
      index: yes
      default: 0
      title: "Рейтинг"
    }
    lat: {
      type: "float"
      default: 0
      title: "Широта"
    }
    lng: {
      type: "float"
      default: 0
      title: "Долгота"
    }
    active: {
      type: "boolean"
      default: yes
      index: yes
    }
    idOwner: {
      type: "number"
      index: yes
      title: "id владельца"
    }
  }
  deps: {
    belongsTo: {
      User: {
        as: 'owner'
        foreignKey: 'idOwner'
        title: "Владелец"
      }
    }
    hasMany: {
      Stand: {
        as: "stands"
        foreignKey: "idShop"
        title: "Витрины в магазине"
      }
      Stuff: {
        as: "stuffs",
        foreignKey: "idShop"
        title: "Товары в магазине"
      }
##      User: {
##        as: "admins"
##        foreignKey: "???"
##      }
    }
  }
}

module.exports.init = (model) ->
  model.prototype.getTitle = ->
    title = @name
    title += " - " + @address if @address
    title

