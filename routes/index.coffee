express = require 'express'
router = express.Router()

#auth = require "../auth.coffee"

# Страница доступа посетителя к каталогу
#router.get '/', (req, res, next) ->
#  res.render 'index', {
#    title: 'AiStuff каталог'
#  }

# Страница доступа посетителя к каталогу
router.get '/', (req, res, next) ->
  #console.error "MAIN"
  if  0 && req.user
    if req.user.admin
      res.redirect "shop/admin"
    else
      #res.redirect "user/home"
      res.render "user/home_view", {
        user: req.user
      }

  else
    res.render 'index_view', {
      title: 'AiStuff каталог'
      user: req.user
    }


#router.get '/user/login', (req, res) ->
#  res.render 'user/login_view', {
#    title: 'Вход'
#  }


# Страница доступа суперадмина
#router.get '/admin', auth.isAdmin, (req, res, next) ->
#  console.log "DB:", req.db
#  res.render 'admin_view', {
#    title: 'AiStuff'
#    user: req.user
#  }

#router.get '/login', (req, res, next) ->
#  res.render 'login', {
#    title: 'Вход'
#  }
#
#router.post '/login', auth.login
#router.post '/register', auth.register
#router.post '/logout', auth.logout
#router.all '/private', auth.isUser, (req, res) ->
#  console.log "user private page", req.user
#  if req.user.isAdmin
#    res.render 'shop/admin_view', {
#      title: 'AiStuff private page'
#      user: req.user
#    }
#  else
#    res.render 'user/home_view', {
#      title: 'AiStuff private page'
#      user: req.user
#    }

router.get '/clean', (req, res) ->
  #console.log "clean req", req.models
  for id, model of req.models
    #console.log "clean req", model
    model.destroyAll (err) ->
      console.log "Destoyed all data in " + id

  res.send "OK"


router.get '/fill', (req, res) ->
  User = req.models.User
  User.create {
    id: 1
    email: "sidr@sidora.net"
    password: '00000',
    name: 'Дмитрий Сидоров'
  }, (err, user) ->
    if err
      res.json {error: user.errors}
    else
      res.json user

  return

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
      next err, obj if next?

up = (model, query, data, next) ->
  model.update {where: query}, data, (err, obj) ->
    if err
      console.error "Не обновлено", err, obj.errors
    else
      console.log "Обновлено", obj
      next obj if next?




module.exports = router;
