###
  Бренд
###

'use strict'

module.exports = {
  id: "Brand"
  title: "Производители"
  logging: yes

  sort: 20

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    name: {
      type: "string"
      index: yes
      title: "Название"
    }
    site: {
      type: "string"
      title: "Ссылка на сайт"
    }
    logo: {
      type: "string"
      title: 'Ссылка на логотип'
    }
  }
  deps: {
    hasMany: {
      Stuff: {
        as: 'stuffs'
        foreignKey: 'idBrand'
        title: 'Производитель'
      }
    }
  }
  debugging: yes
}

module.exports.init = (model) ->
  model.prototype.getTitle = ->
    "brand - " + @name
