'use strict'

caminte = require('caminte')

#console.warn "TEST", caminte.schema.models, caminte.model('User')
#console.warn "TEST", caminte.model('User').findOne
#return;





#type = 'user'
_ = require "underscore"
#User = require "./models/user.coffee"
#Shop = require "./models/shop.coffee"
#Group = require "./models/stuff_group.coffee"
#Stuff = require "./models/stuff.coffee"


User = caminte.model('User')


get = (model, data, next) ->
  console.log "get", model, data
#  model.findOne {where:data}
#  .then (obj) ->
#    obj.isValid (valid) ->
#      if valid
#        console.log "Найдено" , obj
#        next obj if next?
#      else
#        console.log "Найдено невалидное", obj.errors
#  .catch (err) ->
#    console.error err
#
#  return
#
#
  model.findOne {where:data}, (err, obj) ->
    if err
      console.error err
    else if obj
#      obj.isValid (valid) ->
#        if valid
          console.log "Найдено" , obj
          next obj if next?
#        else
#          console.log "Найдено невалидное", obj.errors
    else
      console.log "Не найдено"

add = (model, data, next) ->
  model.create data, (err, obj) ->
    if err
      console.error "Ошибка добавления: ", obj.errors
    else
      console.log "Добавлено", obj
      next obj if next?

up = (model, query, data, next) ->
  model.update {where: query}, data, (err, obj) ->
    if err
      console.error "Не обновлено", err, obj.errors
    else
      console.log "Обновлено", obj
      next obj if next?


get User, {name: "sidr"}
#get User, {id: 1}



#add User, {
#  name: "Дмитрий Сидоров"
#  email: 'sidr@sidora.net'
#  password: '12345'
#}
#up User, {email: 'sidr@sidora.net'}, {name: 'sidr'}, (user) ->
#up User, {id: 1}, {name: 'sidr'}, (user) ->
up User, {id: 1}, {password: '11511'}, (user) ->
  console.log "!!!", user
  get User, {id: 1}



#switch type
#  when 'user'
#    if 1
#      User.find {name: 'Dmitry Sidorov'}, (err, user) ->
#        if err
#          console.error "Пользователь не найден", user.errors
#        else
#          console.log "user" , user
#
#    else
#      User.create {
#        name: "Ксентий Шмоткунос"
#      }, (err, user) ->
#        if err
#          console.error "Не смогли добавить пользователя: ", user.errors
#        else
#          console.log "Пользователь добавлен", user
#
#  when 'shop'
#    if 1
#      Shop.find {name: 'M-video'}, (err, shop) ->
#        console.log "shop" , shop
#
#    else
#      Shop.create {
#        name: "M-video"
#      }, (err, shop) ->
#        if err
#          console.error "Не смогли добавить магазин: ", shop.errors
#        else
#          console.log "Магазин добавлен", shop
#
#  when 'group'
#    if 1
#      Group.find {name: 'Посуда'}, (err, group) ->
#        console.log "group" , group
#
#    else
#      Group.create {
#        name: "Посуда"
#      }, (err, group) ->
#        if err
#          console.error "Не смогли добавить группу: ", group.errors
#        else
#          console.log "Группа добавлена", group
#
#  when 'stuff'
#
#    if 0
#      Stuff.findById 1, (err, stuff) ->
#        console.log "stuff" , stuff
#
#    else
#      Stuff.create {
#        name: "Bamboo plate"
#      }, (err, stuff) ->
#        if err
#          console.error "Не смогли добавить товар: ", stuff.errors
#          #res.error stuff.errors
#
#        else
#          console.log "Товар добавлен", stuff
#
#      #console.log "stuff.features", stuff.features
##  when 'clear'
#


