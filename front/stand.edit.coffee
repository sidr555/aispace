#standConfig = require "./stand.json"
_ = require "underscore"

Layout = require "./stand.layout.coffee"
Row = require "./stand.row.coffee"
Cell = require "./stand.cell.coffee"




App.onPageBeforeInit "stand-layout-edit", (page) ->

  standId = $(page.container).data 'id'

#  try
#    standLayout = $(page.container).data 'cells'
#    console.log "stand cells", standLayout
#    if standLayout
#      standConfig = JSON.parse standLayout
#
#  catch e
#    console.error "Cannot get json"
#
#  unless standConfig
#    standConfig = []  #{rows:[]}
#
#  console.log "init stand layout page", standLayout
##  $button = {};
##  $(".toolbar .button").each (index, button) ->
##    #debugger
##    $button[$(button).data("action")] = $(button);
#
#  layout = new Layout standConfig, $ ".stand-layout"
#  do layout.build


  console.log "get cells"
  layout = new Layout standId, $ ".stand-layout"

  $(".need-row,.need-1-row,.need-2-row,.need-cell,.need-1-cell,.need-2-cell, #undo-button, #save-button").addClass "inactive"


  $(".stand-layout").on "mousedown", (event) ->
    #return

    el = $(event.target)

    _cell = if el.hasClass "cell" then el else el.parent ".cell"
    if _cell.length
      cell = Cell.store[_cell.data("id")]
      row = cell.row
    else
      _row = if el.hasClass "row" then el else el.parent ".row"
      row = Row.store[_row.data("id")] if _row.length

    ###
    console.log cell, row
    console.log "cells store", Cell.store
    console.log "rows store", Row.store
    ###

    unless event.ctrlKey
      do Row.unselect
      do Cell.unselect

    do cell.select if cell
    do row.select if row


    if Cell.selected.length
      $(".need-cell").removeClass "inactive"
    else
      $(".need-cell").addClass "inactive"

    if Row.selected.length
      $(".need-row").removeClass "inactive"
    else
      $(".need-row").addClass "inactive"

    if Row.selected.length == 1
      $(".need-1-row").removeClass "inactive"
    else
      $(".need-1-row").addClass "inactive"

    if Row.selected.length == 2
      $(".need-2-row").removeClass "inactive"
    else
      $(".need-2-row").addClass "inactive"

    if Cell.selected.length == 2
      $(".need-2-cell").removeClass "inactive"
    else
      $(".need-2-cell").addClass "inactive"


  $(".toolbar .button").on "click", (event) ->
    button = $ event.target
    button = button.parent ".button" unless button.hasClass "button"

    unless button.hasClass "inactive"
      console.log button.data "action"
      switch button.data 'action'
        when 'row'
          App.actions Row.getActions()

        when 'cell'
          App.actions Cell.getActions()

        #when 'view'
          #App.view.

        when 'save'
          Row.layout.save ->
            $("#undo-button").addClass "inactive"
            $("#save-button").addClass "inactive"

        when 'undo'
          do Row.layout.undo ->
            if Row.layout.withBackups()
              $("#undo-button").addClass "inactive"
              $("#save-button").addClass "inactive"




  Row.layout.el.on "backup", ->
    $("#undo-button").removeClass "inactive"
    $("#save-button").removeClass "inactive"

#
#
#      console.log "button click", $button
#      if $button.hasClass "add-row-button"
#        App.prompt "Сколько ячеек будет на полке?", "Новая полка", (count) ->
#          unless /^\d+$/.test(count)
#            App.alert "Нужно указать число"
#
#          else
#            $row = $ '<div class="row"></div>'
#            places = count
#            while count-- > 0
#              $row.append buildCell {id: 0, place: 1}, places
#            $(".stand-layout").append $row
#
#      else if $button.hasClass "remove-row-button"
#        selected.rows.forEach ($row) ->
#          do $row.remove
#
#        selected.rows = []
#
#
#      else if $button.hasClass "add-cell-button"
#        if selected.cells.length == 1
#          $cell = selected.cells[0]
#          $row = $cell.parents ".row"
#          row = $row.data "config"
#
#          debugger
#
#
#
#
#      else if $button.hasClass "remove-cell-button"
#        0




#    $row = $ "<div class='row' data-id='" + row.id + "'></div>"
#    $row.data 'config', row
#
#    if row.cells
#      places = _.reduce row.cells, (places, cell) ->
#        places += cell.place
#        places
#      , 0
#
#
#      if places
#        _.each row.cells, (cell) ->
#          $row.append buildCell cell, places
#
#      $container.append $row

#$(".stand-layout").append $ '<div class="row"></div>'


#buildCell = (cell, places) ->
#  console.log "add cell", cell.id, cell
#  title = if cell.stuff then cell.stuff.title else "пусто"
#  $cell = $ "<div class='cell' data-id='" + cell.id + "'><div class='cell-inner'>" + title + "</div></div>"
#  $cell.addClass "col-" + 5 * parseInt(20 * cell.place / places)
#  $cell.addClass "empty" unless cell.stuff
#  $cell
