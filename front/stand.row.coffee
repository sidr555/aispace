_ = require "underscore"

Cell = require "./stand.cell.coffee"

class Row
  id: 0
  @store: {}
  @selected: []

#  @config
#  @container

  @layout: null
  el: null
  data: {}

  cells: off
  width: 0

  @maxId: 0
  lastCellId: 0

  constructor: (@id, @cells) ->
    console.log "construct row", @id, @cells

    @id += parseInt(1000*Math.random()) if @id == "new"

    Row.store[@id] = this

    #console.log "set store"
    @el = $ "<div class='row' data-id='#{@id}'></div>";
    @el.row = this
    #console.log "set row el", @el

    Row.maxId = @id if @id > Row.maxId


  build: ->
    do @updateCellOrder

    @width = _.reduce @cells, (width, cell) ->
      #debugger
      width += cell.config.width unless cell.config.deleted
      width
    , 0

    #console.log "build row", @width

    do @el.empty
    _.each @cells, (cell) =>
      unless cell.config.deleted
        cell.build this
        @el.append cell.el

    this

  #backup: -> do Row.layout.backup

  updateCellOrder: ->
    @lastCellId = 0
    _.each @cells, (cell) => cell.config.index = @lastCellId++
    this


  @get: (id) -> Row.store[id]

  @setLayout: (layout) ->
    Row.layout = layout

  select: ->
    if Row.selected.indexOf(@id) < 0
      #console.log "select row", @id, Row.selected, Row.selected.indexOf @id
      Row.selected.push @id
    @el.addClass "select"
    this

  @unselect: ->
    _.each Row.selected, (id) ->
      Row.get id
      .el.removeClass "select"
    Row.selected = []

  @add: ->
    App.prompt "Сколько ячеек будет на полке?", "Новая полка", (count) ->
      unless /^\d+$/.test(count)
        App.alert "Нужно указать число"

      else
        do Row.layout.backup

        cells = []
        while count--
          cells.push new Cell {
            id: "new"
            width: 1
          }

        row = new Row (Row.maxId + 1), cells
        do row.build
        Row.layout.el.append row.el
        do Row.layout.updateConfig
        #Row.layout.config.rows.push row.data

  @delete: ->
    do Row.layout.backup
    _.each Row.selected, (id) ->
      row = Row.get id
      do row.el.remove
    do Row.layout.updateConfig

  @toggle: ->
    do Row.layout.backup

    rows = []
    _.each Row.layout.config.rows, (row) ->
      if row.id == Row.selected[0]
        row = (Row.get Row.selected[1]).data

      else if row.id == Row.selected[1]
        row = (Row.get Row.selected[0]).data

      rows.push row

    Row.layout.config.rows = rows
    do Row.layout.updateConfig
    do Row.layout.reload



  @getActions: ->
    actions = [{
      text: "Добавить полку"
      color: 'green'
      onClick: Row.add
    }]

    if Row.selected.length == 2
      actions.push {
        text: "Поменять полки местами"
        color: 'orange'
        onClick: Row.toggle
      }
    else
      actions.push {
        text: "Поменять полки местами"
        color: 'gray'
        onClick: -> App.alert "Выберите 2 полки", "Подсказка"
      }

    if Row.selected.length
      actions.push {
        text: "Удалить выбранные полки"
        color: 'red'
        onClick: Row.delete
      }
    else
      actions.push {
        text: "Удалить выбранные полки"
        color: 'gray'
        onClick: -> App.alert "Выберите полки для удаления", "Подсказка"
      }

    actions


module.exports = Row