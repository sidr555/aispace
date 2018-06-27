_ = require "underscore"

Row = null # заинитим позже
Stuff = require "./stuff.coffee"

class Cell
  id: 0
  @store: {}
  @selected: []
  el: null

  width: 0
  row: null
  stuff: no
  title: ""

  prev: 0
  next: 0

  constructor: (@config) ->
    if @config.id == "new"
      @config.id += parseInt(1000*Math.random())
      @config.created = yes

    @id = @config.id

    Cell.store[@id] = this


  build: (@row) ->
    #row = Row.get @config.row
    console.log "row", @row

    @config.row = @row.id unless @config.row

    #@title = @id

    @el = $ "<div class='empty cell' data-id='#{@id}' data-index='#{@config.index}'><div class='cell-inner'>#{@title}</div></div>"
    @el.addClass "col-" + 5 * parseInt(20 * @config.width / @row.width)

#    debugger

    if @config.idStuff
      Stuff.get @config.idStuff, (stuff) =>
        @el.removeClass "empty"
        if @idController
          @el.addClass "controlled"
        @el.find('.cell-inner').text stuff.name
        @stuff = stuff

    console.log "data stuff", @config.idStuff
    this


  select: ->
    #debugger
    console.log "select cell", @id
    @el.addClass "select"
    if Cell.selected.indexOf(@id) < 0
      Cell.selected.push @id
    this

  @get: (id) -> Cell.store[id]


  @getConfig: ->
    config = []
    _.each Cell.store, (cell) ->
      config.push cell.config
    config

  @unselect: ->
    _.each Cell.selected, (id) ->
      Cell.get id
      .el.removeClass "select"
    Cell.selected = []


  @add: ->
    do Row.layout.backup

    #debugger
    row = Row.get Row.selected[0]
    rowId = row.id
    newId = 0

    if Cell.selected.length

      cells = []
      newId = 0

      _.each row.cells, (cell) ->
        if Cell.selected.indexOf(cell.id) >= 0
#debugger
          newId = "new" + parseInt(1000 * Math.random())
          cells.push new Cell {
            id: newId
            row: rowId
            width: 1
            created: yes
          }

        cells.push cell

      row.cells = cells

    else if Row.selected.length
      row = Row.get Row.selected
      newId = "new" + parseInt(1000 * Math.random())
      row.cells.push new Cell {
        id: newId
        row: rowId
        width: 1
        created: yes
      }

    if newId
      do Row.layout.updateConfig
      #do Row.layout.reload
      do row.build
      #      Cell.get newId
      #      .select()
      Row.get rowId
      .select()




  @delete: ->
    do Row.layout.backup

    if Cell.selected.length
      _.each Cell.selected, (cellId) ->
        cell = Cell.get cellId
        cell.config.deleted = yes

      _.each Row.selected, (rowId) ->
        row = Row.get rowId
        #row.cells = _.filter row.cells, (cell) -> Cell.selected.indexOf(cell.id) < 0
        do row.build



  @join: ->
    if Row.selected.length == 1

      do Row.layout.backup

      row = Row.get Row.selected[0]
      #rowId = row.id

      stuff = no
      # общая ширина блока
      widths = _.reduce Cell.selected, (widths, id) ->
        cell = Cell.get id
        stuff = cell.stuff if cell.stuff && !stuff
        widths += cell.config.width
      , 0

      #cells = []
      joinId = 0

      _.each row.cells, (cell) ->
        if Cell.selected.indexOf(cell.id) >= 0
          if joinId
            cell.config.deleted = yes
          else
            joinId = cell.id
            cell.config.width = widths
            cell.config.idStuff = stuff.id
            cell.stuff = stuff if stuff

        #cells.push cell

      #row.cells = cells
      do row.build

      do Row.unselect
      do Cell.unselect
      do row.select
      do Row.layout.updateConfig

  @split: ->
    if Cell.selected.length
      do Row.layout.backup

      #console.log "split cells", Cell.selected
      selectCell = []
      _.each Row.selected, (rowId) ->
        row = Row.get rowId
        cells = []
        newId = 0
        _.each row.cells, (cell) ->
          if Cell.selected.indexOf(cell.id) >= 0
            width = parseInt(cell.config.width/2)
            width = 1 unless width

            cell.config.width = width

            cells.push cell

            newId = "new" + parseInt(1000 * Math.random())
            cells.push new Cell {
              id: newId
              row: row.id
              width: width
              created: yes
            }

            selectCell.push cell.id
            selectCell.push newId
          else
            cells.push cell

        if newId
          row.cells = cells

      if selectCell.length
        selectRow = _.clone Row.selected
        do Row.layout.updateConfig

        _.each selectRow, (idRow) ->
          Row.get idRow
          .build()
          .select()

        _.each selectCell, (idCell) ->
          Cell.get idCell
          .select()



  @toggleStuff: ->
    if Cell.selected.length == 2
      cell1 = Cell.get Cell.selected[0]
      cell2 = Cell.get Cell.selected[1]
      stuff1 = cell1.stuff
      stuff2 = cell2.stuff
      if stuff1 or stuff2
        do Row.layout.backup
        if stuff2 and stuff2.id
          cell1.config.idStuff = stuff2.id
          cell1.stuff = stuff2
        else
          cell1.config.idStuff = 0
          cell1.stuff = no

        if stuff1 and stuff1.id
          cell2.config.idStuff = stuff1.id
          cell2.stuff = stuff1
        else
          cell2.config.idStuff = 0
          cell2.stuff = no

        do cell1.row.build
        do cell2.row.build unless cell1.row.id == cell2.row.id


  @showStuff: ->
    if Cell.selected[0]
      App.view.router.loadPage('/cell/' + Cell.selected[0] + '/stuff');
        


  @showPoints: ->
    alert "setPoints"
    if Cell.selected[0]
      App.view.router.loadPage('/cell/' + Cell.selected[0] + '/points');


  @getActions: ->
    Row = require "./stand.row.coffee"

    console.log "get Cell actions", Cell.selected, Row.selected

    options = {
      add: {
        text: "Добавить ячейку"
        color: 'green'
        hint: "Выберите ячейку, перед которой будет вставлена новая, или полку для вставки ячейки в конец",
        onClick: Cell.add
      }
#      toggle: {
#        text: "Поменять ячейки местами"
#        color: 'orange'
#        hint: "Выберите 2 ячейки"
#        onClick: Cell.toggle
#      }
      toggleStuff: {
        text: "Поменять товары местами"
        color: 'orange'
        hint: "Выберите 2 ячейки"
        onClick: Cell.toggleStuff
      }
      join: {
        text: "Объединить ячейки"
        color: 'blue'
        hint: "Выберите соседние ячейки для объединения"
        onClick: Cell.join
      }
      split: {
        text: "Разделить выбранные ячейки"
        color: 'blue'
        hint: "Выберите ячейки для разделения"
        onClick: Cell.split
      }
      delete: {
        text: "Удалить выбранные ячейки"
        color: 'red'
        hint: "Выберите ячейки для удаления"
        onClick: Cell.delete
      }
      showStuff: {
        text: "Товар в ячейке"
        color: 'black'
        hint: "Выберите ячейки"
        onClick: Cell.showStuff
      }
      showPoints: {
        text: 'Порты для ячейки'
        color: 'black'
        hint: "Выберите ячейки"
        onClick: Cell.showPoints
      }
    }

    activeOptions = []

    if Row.selected.length == 1 then activeOptions.push "add"

    if Cell.selected.length == 2
      activeOptions.push "toggle"
      activeOptions.push "toggleStuff"


    if Row.selected.length == 1 and Cell.selected.length > 1
      row = Row.get Row.selected[0]
      inRange = no
      selCount = 0
      joinable = yes
      _.each row.data.cells, (cell) ->
        if joinable
          isSel = Cell.selected.indexOf(cell.id) >= 0

          if inRange
            if isSel
              selCount++
            else
              inRange = no
          else
            if isSel
              if selCount > 0
                joinable = no
              else
                inRange = yes
                selCount++

      if joinable then activeOptions.push "join"

    if Cell.selected.length
      activeOptions.push "split"
      activeOptions.push "delete"
      activeOptions.push "showPoints"
      activeOptions.push "showStuff"

    actions = []
    _.each options, (data, id) ->
      if 0 > activeOptions.indexOf id
        data.color = "gray"
        data.onClick = -> App.alert data.hint, "Подсказка"

      actions.push data

    #console.log "actions", actions
    actions


module.exports = Cell