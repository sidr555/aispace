###
  Загрузчик моделей
###


caminte = require 'caminte'
fs = require 'fs'
path = require 'path'

modelDir = path.resolve __dirname, '.'
modelList = fs.readdirSync modelDir

dbConf = require '../database'
database = dbConf[process.env.NODE_ENV || 'dev']

schema = new caminte.Schema database.driver, database
#caminte.schema = schema
#caminte.model = function (name){
#    //return caminte.schema.models[name.toLowerCase()];
#    return caminte.schema.models[name];
#};


Models = (modelName) -> schema.models[modelName]

Models.schema = schema;

caminteTypeMap = {
  number: schema.Number
  integer: schema.Integer
  float: schema.Float
  double: schema.Double
  real: schema.Real
  boolean: schema.Boolean
  date: schema.Date
  string: schema.String
  text: schema.Text
  json: schema.Json
  blob: schema.Blob
}


Models.init = (app) ->

  @models = app.models = {}

  console.info "Load models"
  for modelFile in modelList
    if modelFile.match /^[A-Z]\w+\.coffee$/
      #modelName = modelFile.replace /\.coffee$/i, ''

      #continue unless modelName == 'Brand'

      #console.log "require ", modelName

      config = require modelDir + '/' + modelFile
      if config.id and config.schema
        config.dbKey = config.id.toLowerCase() unless config.dbKey?

        caminteSchema = {}
        for field, fieldConfig of config.schema
          if fieldConfig.type == "date"# and !fieldConfig.decorate
            #console.log "DATE", field
            config.schema[field].decorate = (date) ->
              unless  date.getTime()
                ""
              else
                date.prettyDateTime()


          caminteSchema[field] = fieldConfig
          caminteSchema[field].type = caminteTypeMap[fieldConfig.type]

        model = schema.define config.dbKey, caminteSchema
        model.id = config.id
        model.config = config
        #model.schema = config.schema

        model.debug = ((model) ->
          -> if model.config.debugging then console.log.apply console, arguments
        )(model)

#        if typeof config.init == "function"
#          console.log " - init " + id, model
#          config.init model, @models

        @models[model.id] = model

        #console.log " - " + modelName

  console.log "Init models"
  for id, model of @models
    if typeof model.config.init == "function"
      #console.log " - init " + id, model
      model.config.init model, @models

#      if model.config.logging
#        model.log = ((id, model) ->
#          (params) ->
#            params.model = model.id
#            app.models.Log.create params
#        )(id, model)

  console.log "Building deps for models"
  for id, model of @models
    if model.config.deps?
      if model.config.deps.hasMany
        for depName, depParams of model.config.deps.hasMany
          if @models[depName]
            #console.log " - " + id + " has many " + depName + " as " + depParams.as
            model.hasMany @models[depName], depParams
          else
            console.error "!!! Bad model name: " + depName

      if model.config.deps.belongsTo
        for depName, depParams of model.config.deps.belongsTo
          if @models[depName]
            #console.log " - " + id + " belongs to " + depName + " as " + depParams.as
            model.belongsTo @models[depName], depParams
          else
            console.error "!!! Bad model name: " + depName

#  if typeof schema.autoupdate == 'function' && process.env.AUTOUPDATE
#    schema.autoupdate (err) ->
#      if err
#        console.error err

  return app

module.exports = Models;
