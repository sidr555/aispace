express = require 'express'
router = express.Router()

Shop = (require '../models') 'Shop'
User = (require '../models') 'User'

router.get "/add", (req, res) ->
  User.findOne {where: {id:1}}, (err, user) ->
    console.log "shop owner user", user

    shop = user.shops.build {
      name: "m-vidoe 22"
      address: "г. Иркутск"
    }

    shop.save (err, data) ->
      console.log "shop", data
      if err
        res.json {error: err.message}
      else if data.errors
        res.json {error: data.errors}
      else
        res.json data


#  console.log Shop
#  Shop.create {
#    name: "M-Video"
#    address: "г. Иркутск",
#    idOwner: 1
#  }, (err, data) ->
#    console.log "shop", data
#    if err
#      res.json {error: err.message}
#    else if data.errors
#      res.json {error: data.errors}
#    else
#      res.json data

router.get '/:id', (req, res) ->
  Shop.findById {where: {id: req.params.id}}, (err, shop) ->
    console.log "get shop id = ", req.params.id
    Shop.findById req.params.id, (err, data) ->
      if err
        res.json {error: err.message}
      else
        console.log "shop", data, data.owner

#        data.owner (err, user) ->
#          if err
#            res.json {error: err.message}
#          else
#            console.log "owner", user
#            data.user = user
        res.json data




router.get "/", (req, res) ->
  Shop.all (err, list) ->
    console.log "shops", list
    if err
      res.json {error: err.message}
    else if list.errors
      res.json {error: list.errors}
    else
      res.json list




#router.get "/add", auth.isAdmin, (req, res, next) ->
#  res.render 'shop/add_view', {
#    title: 'AiStuff админка магазина'
#    user: req.user
#  }

# Страница доступа посетителя к витрине конкретного магазина
#router.get '/:id', (req, res, next) ->
#  shop = new Shop(req.params.id)
#  shop.get()
#  .then ->
#    res.render 'index_view', {
#      title: 'AiStuff витрина'
#      user: req.user
#    }
#  .catch (err) ->
#    console.log "cannot load", err
#
#    shop.update {
#      name: "Детский мир"
#      address: "Иркутск, ул. Урицкого, 3"
#      lat: 52.285064
#      lng: 104.289940
#    }
#    next err
#
## Страница доступа администратора витрины магазина
#router.get '/:id/admin', auth.isShopAdmin, (req, res, next) ->
#  res.render 'admin_view', {
#    title: 'AiStuff админка магазина'
#    user: req.user
#  }





module.exports = router;
