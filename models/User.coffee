'use strict'

md5 = require "md5"

module.exports = {
  id: "User"
  title: "Пользователи"
  logging: yes

  sort: 30

  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    name: {
      type: "string"
      index: yes
      title: "Имя"
    }
    email: {
      type: "string"
      "null": no
      unique: yes
      title: "E-mail"
    }
    password: {
      type: "string"
      title: "Пароль"
    }
    gender: {
      type: "string"
      limit: 1
      default: "м"
      index: yes
      title: "Пол"
    }
    city: {
      type: "number"
      index: yes
      title: "Город"
    }
    birthday: {
      type: "date"
      index: yes
      default: null
      title: "Дата рождния"
    }
    createDate: {
      type: "date"
      default: Date.now
      title: "Дата регистрации"
    }
    lastVisitDate: {
      type: "date"
      index: yes
      default: null
      title: "Последний визит"
    }
    active: {
      type: "boolean"
      default: yes
      index: yes
      title: "Активен"
    }
  }
  deps: {
    hasMany: {
      Shop: {
        as: "shops"
        foreignKey: "idOwner"
        title: "Владелец магазинов"
      }
      Log: {
        as: "actions"
        foreignKey: "user"
        title: "Действия пользователя"
      }
    }
  }
}

module.exports.init = (model) ->
  model.prototype.getTitle = -> @email + ' - ' + @name

  model.validatesLengthOf  'password', {min: 3,message: {min: 'Пароль не менее 3 символов'}}
  model.validatesInclusionOf 'gender', {in: ['м', 'ж'], message: 'Пол - м / ж'}
  #model.validatesUniquenessOf 'email', {message: 'Email занят'}

  model.validate 'name', (err) ->
    do err unless @name
  , {message: 'Забыли имя?'}


  model.validate 'email', (err) ->
    do err unless /^[-a-z0-9!#$%&'*+/=?^_`{|}~]+(?:\.[-a-z0-9!#$%&'*+/=?^_`{|}~]+)*@(?:[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(?:aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$/.test(@email)
  , {message: 'Неверный Email'}

  model.beforeCreate = (next) ->
    @password = md5 @password unless @password.match /^[0-9a-f]{32}$/
    @createDate = new Date() unless @createDate
    do next

