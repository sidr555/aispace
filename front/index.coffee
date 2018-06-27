#Framework7 = require "framework7"
window.$ = Dom7

window.App = new Framework7 {
  material: off
  pushState: yes
  swipePanel: 'left'
}

mainView = App.view = App.addView('.view-main');


mqtt_client = require "./mqtt.coffee"

$ ".link-login"
.on 'click', ->
  do App.loginScreen


App.message = (text) ->
  App.addNotification {
    title: text
    hold: 5000
    closeIcon: false
    closeOnClick: true
  }

App.error = (err) ->
  console.log "error", err

  title = "Ошибка"

  try
    err = JSON.parse err
    if typeof err == "object"
      switch err.status
        when 403
          title = "Ошибка доступа"
        when 404
          title = "Не найдено"

      text = err.message
  catch
    text = err

  App.addNotification {
    title: title
    hold: 5000
    subtitle: text
    closeIcon: false
    closeOnClick: true
    additionalClass: "error-notification"
  }

$(document).on "ajax:error", (e) ->
  xhr = e.detail.xhr
  switch xhr.status
    when 403 then App.error xhr.response || "Доступ запрещен"
    when 404 then App.error xhr.response || "Не найден объект по id"
    when 500 then App.error xhr.response
    else  App.error "Неизвестная ошибка [" + xhr.response + "] " + xhr.response


#console.log "app", App

App.onPageBeforeInit "model-item", (page) ->

  model = $(page.container).data "model"
  itemId = $(page.container).data "item"
#
#  if model == "Stuff" or model == "StuffGroup"

  form = $($('form')[0])
  $('#save-model').on "click", ->
    form.trigger "submit"

  form.on 'form:success', (e) ->
    try
      data = JSON.parse e.detail.data

      if data.error
        alert "Ошибка: " + data.error

      else if data.id
        App.message "Объект сохранен: " + model + ":" + data.id
        mainView.router.load {
          url:'/db/' + model
          ignoreCache: yes
        }

    catch e
      App.error "Ошибка сохранения"

  #debugger
  #console.log "delete button", $(".delete-item")
  $(".delete-item").on "click", (e) ->
    #debugger
    do e.stopPropagation
    do e.preventDefault

    $.get "/db/" + model + "/delete/" + itemId,
      ->
        App.message "Удален объект: " + model + ":" + itemId
        mainView.router.load {
          url:'/db/' + model
          ignoreCache: yes
        }


require "./stand.edit.coffee"
require "./stand.view.coffee"




#App.onAjaxSuccess = (next) ->
#$(document).on "ajax:success", (e) ->
#  console.log "AJAX SUCCEED"
#  debugger
#  response = e.detail.xhr.response
#  #console.log "onAjaxSuccess response", response, response.substr 0, 2
#  if '{"' == response.substr 0, 2
#    response = JSON.parse response
#
#  next response
#
#
#App.onPageBeforeInit "login", (page) ->
#  $('form.ajax-submit').on 'form:success', (e) ->
#    user = JSON.parse e.detail.data
#    App.user = user;
#    console.log("logged in", user.id);
#
#    if user.admin
#      mainView.loadPage '/shop/admin'
#    else
#      mainView.loadPage 'user/home'
#
#App.onPageBeforeInit "register", (page) ->
#  $('form.ajax-submit').on 'form:success', (e) ->
#    debugger
#    user = JSON.parse e.detail.data
#    console.log("registered in", user.id);
#    App.user = user;
#
#    debugger
#    if user.isAdmin
#      mainView.loadPage '/shop/admin'
#    else
#      mainView.loadPage 'user/home'
#
#
#
#
#
