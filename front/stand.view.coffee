#standConfig = require "./stand.json"
_ = require "underscore"

#Layout = require "./stand.layout.coffee"
#Row = require "./stand.row.coffee"
#Cell = require "./stand.cell.coffee"
#

App.onPageBeforeInit "stand-layout-view", (page) ->

  standId = $(page.container).data 'id'

#  $(".cell").each (index, el) ->

  $(".cell-inner").on "click", (e) ->
    cell = $ e.target
    cell = cell.closest(".cell") unless cell.hasClass "cell"
    console.log "click on cell", cell

    if cell.data "controller"
      if cell.hasClass "highlight"
        $.ajax
          dataType: "ajax"
          url: "/cell/" + cell.data("id") + "/turnOff"
          success: (state) ->
            cell.removeClass "highlight"
      else
        $.ajax
          dataType: "ajax"
          url: "/cell/" + cell.data("id") + "/turnOn"
          data: {
            color: "green"
          }
          success: (state) ->
            cell.addClass "highlight"
