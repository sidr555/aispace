express = require 'express'
router = express.Router()

#User = require "../models/user_model.coffee"
####auth = require "../auth.coffee"

User = (require '../models') 'User'

router.get '/logout', (req, res) ->
  #console.log "logout"
  do req.logout
  #res.redirect "/user/login"
  res.send {}

#router.get '/login', (req, res) ->
#  res.render 'user/login', {
#    title: 'Вход'
#  }



router.get '/:id', (req, res) ->
  console.log "get user id = ", req.params.id
  User.findById req.params.id, (err, user) ->
    if err then next err
    else

      out = {user: user}

      user.shops (err, shops) ->
        #console.log "user shops", shops

        out.shops = shops
        console.log "user", out

        res.json out

#      res.render "user/list_view", {
#        title: "Список пользователей"
#        users: users
#      }


# GET users listing.
router.get '/', (req, res) ->
  User.all (err, users) ->
    console.log "list", users
    if err
      res.json {error: users.errors}
    else
      res.json users



#router.get '/home', (req, res, next) ->
#  #console.log "111";
#  res.render "user/home_view", {
#    user: req.user
#  }
#
#
#router.get '/register', (req, res) ->
#  res.render 'user/register_view', {
#    title: 'Регистрация'
#  }
#
#router.get '/remember', (req, res) ->
#  res.render 'user/remember_view', {
#    title: 'Напомнить пароль'
#  }

#router.get '/login', auth.login
router.post '/login', auth.login
#router.post '/register', auth.register
#
#
#router.post '/remember', (req, res, next) ->
#  console.log "remember post",
#    auth.remember req, res, next
#


module.exports = router;
