###
  Роутер для просмотра и редактирования информации в базе
###

express = require 'express'
router = express.Router()
async = require "async"
jade = require "jade"
_ = require "underscore"
moment = require "moment"
fs = require "fs"

router.get "/export", (req, res, next) ->

  os = require 'os'

  console.log "Hostname", os.hostname()

  backup = {
    host: os.hostname()
    date: moment().format()
    models: {}
  }

  filename = "backup-" + os.hostname() + '-' + moment().format("YYYY-MM-DD") + '.json';

  modelsCount = _.size(req.models);

  _(req.models).each (model) ->
    #console.log " === " + model.id + " === "

    req.params.model = model.id
    data = loadModelParams(req, res)
    if data.error then next new Error(data.error)
    else
      data.model.all (err, list) ->
        if err
          console.log "error", err
          next err
        else
          backup.models[model.id] = list
          if --modelsCount <= 0
            #console.log("Backup!", backup);
            file = JSON.stringify backup
            res.writeHead(200, {
              'Content-Type': "text/json"
              'Content-Disposition': 'attachment; filename=' + filename
            })
            res.write file
            res.end()

router.get "/import", (req, res, next) ->
  res.render "db/import"

router.post "/import", (req, res, next) ->
  file = req.files.file[0]
  #console.log "import models from file", file
  if file && file.size
    console.log "open file", file.path
    fs.open file.path, 'r', (err, fd) ->
      if err then next err
      else
        console.log "file opened", file.path, fd
        fs.readFile fd, {encoding: 'utf-8'}, (err, text) ->
          console.log "read file"
          backup = JSON.parse text
          if backup && backup.models
            console.log "file read", file.path#, backup.models
            if err then next err
            else
              _(req.models).each (model) ->
                console.log "model", model.id
                if backup.models[model.id]
                  console.log "flush model", model.id
                  req.params.model = model.id
                  data = loadModelParams(req, res)
                  if data.error then next new Error data.error
                  else
                    data.model.destroyAll (err) ->
                      if err then next err
                      else
                        #console.log "fill model", model.id
                        _(backup.models[model.id]).each (item) ->
                          data.model.create item, (err) ->
                            if err then next err
                            else
                              console.log "create item", item



router.get "/:model/add", (req, res, next) ->
  data = loadModelParams(req, res)
  if data.error then next new Error(data.error)
  else
    res.render "db/add", data


router.get '/:model/:id/json', (req, res, next) ->
  data = loadModelParams(req, res)
  if data.error then next new Error(data.error)
  else
    #console.log "get model json", req.params.id
    data.model.findOne {where: {id: req.params.id}}, (err, itemData) ->
      if err
        next err
      else unless itemData
        next {status: 404}
      else
        console.log "JSON", req.params.model, req.params.id, itemData.getJson()
        res.json itemData.getJson()



router.get "/:model/:id", (req, res, next) ->
  data = loadModelParams(req, res)
  if data.error then next new Error(data.error)
  else
    data.model.findOne {where: {id: req.params.id}}, (err, itemData) ->
      if err
        next err
#        res.status 500
#        .send err.message
      else
        data.itemData = itemData

        data.render = jade.renderFile

        if req.params.model.toLocaleLowerCase() == 'stuff'
          for feature in itemData.featureConfig
            console.log feature.title, feature

        # если для поля указан шаблон, отрисуем его
        for field, fieldData of data.fields
          if fieldData.template && !/jade$/.test(fieldData.template)
            fieldData.template = "views/" + fieldData.template + ".jade"

        # подгрузим асинхронно связанные модели
        deps = data.model.config.deps
        if deps?
          fnDep = [];

          if deps.hasMany?
            data.hasMany = []

            for depName, depParams of deps.hasMany
              if typeof itemData[depParams.as] == "function"
                fnDep.push ((itemData, depName, depParams) ->
                  (next) ->
                    itemData[depParams.as] (err, depData) ->
                      unless err
                        if depData.length
                          data.hasMany.push {
                            errors: depData.errors
                            model: {
                              id: depName
                              title: depParams.title || depName
                            }
                            items: depData
                          }
                      next err
                ) itemData, depName, depParams


          if deps.belongsTo?
            data.belongsTo = []

            for depName, depParams of deps.belongsTo
              if itemData[depParams.foreignKey] && typeof itemData[depParams.as] == "function"
                fnDep.push ((itemData,depName, depParams) ->
                  (next) ->
                    itemData[depParams.as] (err, depData) ->
                      result = {
                        model: {
                          id: depName
                          title: depParams.title || depName
                        }
                      }
                      if err
                        result.error = err.message

                      if depData
                        if depData.errors
                          result.error = depData.errors
                        else
                          result.data ={
                            id: depData.id
                            title: if depData.getTitle? then depData.getTitle() else depData.name || depData.id
                          }
                      data.belongsTo.push result
                      next null

                ) itemData, depName, depParams



          # подгрузим лог изменений
          if data.model.config.logging
            fnDep.push ((model, id) ->
              (next) ->
                #console.log "Log model", req.models.Log, model.id, id
                req.models.Log.all {
                  where: {
                    model: model.id,
                    item: id}
                }, (err, log) ->
                  unless err
                    data.log = log
                    next null

            )(data.model, req.params.id)

          async.parallel fnDep, (err, result) ->
            #console.log "parallels", err, result
            if err
              next err
#              res.error err.message
#              res.status 500
#              .send err.message
            else
              #console.log "Full data: ", data
              #console.log "belongsTo", data.belongsTo
              #console.log "belongsTo", data.belongsTo.model, data.belongsTo.data
              #console.log "hasMany", data.hasMany.model, data.hasMany.data
              res.render "db/edit", data

        else
          res.render "db/edit", data

#router.post "/:model/find", (req, res, next) ->
#  data = loadModelParams(req, res)
#  if data.error then next new Error(data.error)
#  else
#    console.log "req.body", req.body
#    res.send {}
#
#    data.model.all (err, list) ->
##console.log list
##      if err
##        next err
##        res.status 500
##        .send err.message
##      else
##        data.list = list
##        res.render "db/list", data



router.get "/:model", (req, res, next) ->
  data = loadModelParams(req, res)
  if data.error then next new Error(data.error)
  else
    data.model.all (err, list) ->
      #console.log list
      if err
        next err
#        res.status 500
#        .send err.message
      else
        data.list = list
        res.render "db/list", data


router.get "/", (req, res, next) ->
  data = {models:{}}
  #models = _(req.models).reject (item) -> return item.hide
  models = _(req.models).sortBy (model) ->
    return (model.config.sort || 100500)

  console.log "models", models

  res.render "db/models", {models:models}


router.post "/:model/save", (req, res, next) ->
  data = loadModelParams(req, res)
  console.log "model save data", data
  if data.error then next new Error(data.error)
  else
    console.log req.body
    data.model.create req.body, (err, item) ->
      console.log "CREATE", data.model.id, err, item
      if err
        next err
#        res.status 500
#        .send err.message
      else if item.errors
        next item.errors
#        res.status 500
#        .send item.errors
      else
        if req.body.id
          req.log {
            type: "create"
            model: data.model.id
            item: req.body.id
            user: req.user.id
          }
        else
          req.log {
            type: "update"
            model: data.model.id
            item: item.id
            user: req.user.id
          }

        res.json item

router.get "/:model/delete/:id", (req, res, next) ->
  data = loadModelParams(req, res)
  if data.error then next new Error(data.error)
  else
    console.log "DELETE", data.model.id, req.params.id
    data.model.remove {where: {id: req.params.id}}, (err) ->
      if err then next err
      else
        req.log {
          type: "delete"
          model: data.model.id
          item: req.params.id
          user: req.user.id
        }
        res.json {}



loadModelParams = (req) ->
  modelName =  req.params.model.charAt(0).toUpperCase() + req.params.model.substr(1)
  model = req.models[modelName]

  unless model?
    {error: "Неизвестная модель " + modelName}
#    res.status 500
#    .send "Неизвестная модель " + modelName
#    false
  else

    fields = []
  #  model.forEachProperty (name) ->
  #    fields.push name
  #    console.log "Model field", name, model.fields


    #console.log "Model fields", fields
    {
      id: req.params.model
      modelName: modelName
      modelTitle: model.config.title || modelName
      model: model
      fields: model.config.schema
      #fields: fields
    }


module.exports = router;
