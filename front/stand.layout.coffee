_ = require "underscore"

Row = require "./stand.row.coffee"
Cell = require "./stand.cell.coffee"

class Layout

  rows: []
  backups: []
  changed: no
  @config: {}

  constructor: (@id, @el) ->
    Row.setLayout this
    do @loadCells

  build: ->
    #@config
    console.log "Build layout with cells", @config
    #if @config.length

    try
      rowCells = {}
      maxRow = 0

      _.each @config, (cellConfig) ->
        cell = new Cell cellConfig
        idRow = cell.config.row
        maxRow = idRow if idRow > maxRow

        if rowCells[idRow]?
          rowCells[idRow].push cell
        else
          rowCells[idRow] = [cell]

      for idRow in [0..maxRow]
        if rowCells[idRow]?
          row = new Row idRow, rowCells[idRow].sort (a,b) -> if a.index < b.index then -1 else 1
          do row.build
          @el.append row.el
          @rows.push row

      console.log "build layout complete"
    catch e
      debugger

  loadCells: ->
    $.ajax {
      url: "/stand/" + @id + "/cells"
      dataType: "json"
      success: (@config) =>
        console.log "found cells", @config
        #layout = new Layout standId, cells, $ ".stand-layout"
        do @reload
    }


  updateConfig: ->
    console.log "update layout config"
    @config = []
    _.each Cell.store, (cell) =>
      @config.push cell.config

  clean: ->
    do @el.empty
    Row.store = {}
    Cell.store = {}
    Row.selected = []
    Cell.selected = []

  reload: ->
    do @clean
    do @build


  #cloneConfig: -> JSON.parse JSON.stringify @config

  withBackups: -> @backups.length > 0

  backup: ->
    #@backups.push @cloneConfig()
    @backups.push JSON.stringify @config
    @changed = yes
    @el.trigger "backup"


  undo: (next) ->
    @config = JSON.parse @backups.pop()
    do @reload
    do next if next?

  save: (next) ->
    console.log @config
    $.ajax {
      method: "post"
      url: "/stand/" + @id + "/set_layout"
      data: {
        cells: JSON.stringify @config
      }
      success: (result) =>
        do @loadCells if result == "OK"
        @changed = no
        @backups = []
        do next if next?

#      error: (a, b, c) ->
#        App.alert "Ошибка сохранения"
#        console.log "save error", a, b, c
    }

module.exports = Layout