###
  Журнал изменений
###

'use strict'

modelTitles = {}
typeTitles = {
  create: "Объект добавлен"
  delete: "Объект удален"
  update: "Объект изменен"
}

module.exports = {
  id: "Log"
  title: "Журнал действий в базе"
  schema: {
    id: {
      type: "number"
      index: yes
      unique: yes
    }
    type: {
      type: "string"
      title: "Тип действия"
      values: typeTitles
      decorate: (type) ->
        typeTitles[type] || type
    }
    model: {
      type: "string"
      index: yes
      title: "id модели"
      decorate: (model) ->
        modelTitles[model]

    }
    item: {
      type: "number"
      index: yes
      title: "id объекта модели"
    }
    user: {
      type: "number"
      index: yes
      title: "id пользователя"
    }
    time: {
      type: "date"
      index: yes
      title: "Время"
      decorate: (val) -> val.prettyDateTime()
    }
    info: {
      type: "json"
      title: "Информация об изменении"
      decorate: (val) ->
        val.message
    }
  }
  deps: {
    belongsTo: {
      User: {
        as: 'who'
        foreignKey: 'idUser'
        title: 'Пользователь'
      }
    }
  }
#  debugging: yes
}


module.exports.init = (model, models) ->

  for modelId, modelConfig of models
    modelTitles[modelId] = modelConfig.config.title || modelId

  model.prototype.getTitle = ->
    type = if (model.config.schema.type.values[@type]) then model.config.schema.type.values[@type] else @type
    #modelTitle = models[@model].config.title || @model
    #console.log "getTitle", @model, models[@model]

    #console.log "titles", modelTitles

    out = @time.prettyDateTime() + ": " + type + " " + modelTitles[@model] + ":" + @item
    out += ": " + @info.message if @info.message
    out

  model.prototype.getInfo = ->
    out = if (model.config.schema.type.values[@type]) then model.config.schema.type.values[@type] else @type
    out += ":" + @info.message if @info.message

  model.beforeCreate = (next) ->
    @time = new Date() unless @time
    @info = {message: @info} if typeof @info == "string"
    do next
