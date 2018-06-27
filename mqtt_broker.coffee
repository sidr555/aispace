###
 * Author: Dmitry Sidorov
 * Email: sidr@sidora.net
 * Date: 13.10.17
 * MQTT - брокер
###

mosca = require 'mosca'

dbConf = (require './database')['mqtt']

broker = new mosca.Server {
    #port: 1883
    backend: {
        type: 'redis'
        redis: require 'redis'
        host: dbConf.host
        port: dbConf.port
        db: dbConf.database
        return_buffers: true
    }
    #keepalive: 5
    #persistence: {
    #    factory: mosca.persistence.Redis
    #}
    http: {
        port: 1884,
        bundle: true,
        static: './'
    }
}


ping = ->
    message = {
        topic: 'ping'
        payload: 'abcde'
        qos: 2, # 0, 1, or 2
        retain: no # or yes
    }

    broker.publish message, ->
        console.log "done!"

    console.log 'ping..'

    setTimeout ping, 5000


# mqtt server is ready
broker.on 'ready', ->
    console.log('Mosca server is up and running')
    do ping


# client is connected
broker.on 'clientConnected', (client) ->
    console.log 'client connected', client.id


# message is received
broker.on 'published', (packet, client) ->
    console.log 'Published', packet


module.exports = broker;