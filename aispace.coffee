'use strict'

http = require 'http'
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
flash = require 'express-flash'
multiparty = require 'multiparty' #F7
errorlog = require 'express-errorlog'


nconf = require "nconf"
nconf.argv().env().file {
  file: "config.json"
}

app = do express

app.config = nconf

app.db = require( "redis" ).createClient()

RedisStore = require( "connect-redis" )(session)

# view engine setup
app.set 'views', (path.join __dirname, 'views')
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(require('less-middleware')(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));

app.use(session {
  secret: app.config.get 'redis:secret'
  key: 'aid'
  resave: no
  saveUninitialized: no
  store: new RedisStore {
    host: 'localhost'
    port: 6379
    client: app.db
  }
});
app.use flash()


models = require './models'
models.init(app)


app.use (req, res, next) ->
  req.db = app.db
  req.config = app.config

  req.models = app.models

  req.user = { # fixme login
    id: 1
    name: "Дмитрий Сидоров"
    email: "sidr@sidora.net"
  }

  req.log = (data) ->
    console.log "ADD LOG MESSAGE", data
    app.models.Log.create data

  res.error = (message) ->
    next new Error(message)


  if req.method == "POST"
    #console.log "POST BODY", req.method, req.body

    # Привет F7!
    form = new multiparty.Form()
    form.parse req, (err, fields, files) ->
      #console.log "form fields", fields
      #console.log "form files", files
      for key, val of fields
        if val && val.length==1
          req.body[key] = val[0]
        else
          req.body[key] = val

      req.files = files
      do next
  else
    do next




####(require "./auth.coffee").init app

#app.use(auth.passport.initialize());
#app.use(auth.passport.session());


#app.use('/shop', require './routes/shop_route.coffee');
#app.use('/user', require './routes/bak/user_route.coffee');
##app.use('/user', require './routes/users.coffee');
#app.use('/shops', require './routes/shops.coffee');
app.use('/controller', require './routes/controllers.coffee');
app.use('/stand', require './routes/stands.coffee');
app.use('/cell', require './routes/cells.coffee');
app.use('/db', require './routes/db.coffee');
app.use('/', require './routes/index.coffee');

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found');
  err.status = 404;
  next err


app.use errorlog
app.use (err, req, res, next) ->
  res.json err



# Create HTTP server.
server = http.createServer app

# Listen on provided port, on all network interfaces.
server.listen (app.config.get "express:port"), app.config.get("express:address")

server.on 'listening', ->
  address = do server.address
  console.log "Listening on ", address.address, " port ", address.port

  mqttServer = require "./mqtt_broker.coffee"
  #mqttServer.

console.log("mosca", require.resolve("mosca"));


  #console.log("Models: ", app.models)

  #require './test.coffee'


# Event listener for HTTP server "error" event.
server.on 'error', (error) ->
  throw error if error.syscall != 'listen'

  bind = if typeof port == 'string' then 'Pipe ' + port else 'Port ' + port

  # handle specific listen errors with friendly messages
  switch error.code
    when 'EACCES'
      console.error bind + ' requires elevated privileges'
      process.exit 1
    when 'EADDRINUSE'
      console.error bind + ' is already in use'
      process.exit 1
    else
      throw error



zeroify = (val) ->
  val = "0" + val if val < 10
  val


Date.prototype.prettyDateTime = ->
  zeroify(@getDate()) + "." + zeroify((@getMonth()+1)) + "." + (@getFullYear()) + " " + zeroify(@getHours()) + ":" + zeroify(@getMinutes()) + ":" + zeroify(@getSeconds())

