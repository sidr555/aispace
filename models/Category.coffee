###
  Группа (категория) товара,
  Определяет схожий набор характеристик, наример, обувь, внедорожник, выпечка
  Является шаблоном для создания товаров
  Группы имеют древовидную структуру
  Характеристики вложенных групп расширяют родительские
###

'use strict'

module.exports = {
  id: "Category"
  title: "Категории товаров"

  sort: 24

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    name: {
      type: "string"
      limit: 30
      index: yes
      title: "Название"
    }
    idParent: {
      type: "number"
      index: yes
      default: null
      title: "id родительской категории"
    }
    fixedFeatures: {
    # не давать менять характеристики админам
      type: "boolean"
      default: yes
      index: yes
      title: "фиксированные характеристики"
    }
  }

  deps: {
    belongsTo: {
      Category: {
        as: 'parent'
        foreignKey: 'idParent'
        title: 'Состоит в группе'
      }
    }
    has: {
      Category: {
        as: 'children'
        foreignKey: 'idParent'
        title: 'Содержит группы'
      }
#      Feature: {
#        as: 'feature',
#        foreignKey: 'idGroup'
#      }
      Stuff: {
        as: 'stuffs',
        foreignKey: 'idGroup'
        title: 'Товары в группе'
      }
#      StuffValue: {
#        as: 'value'
#        foreignKey: 'idGroup'
#      }
    }
  }
}