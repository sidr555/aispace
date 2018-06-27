mqtt = require "mqtt"

client = mqtt.connect "ws://localhost:1884"
#client = mqtt.connect "ws://192.168.0.30:1883"
#client = mqtt.connect "ws://test.mosquitto.org"

console.log "CLIENT", client

client.on "connect", ->
  console.log "client is connected"
  client.subscribe "ping"
  client.subscribe "test/browser"
  client.publish "test/browser", "hello"


client.on "message", (topic, message) ->
  console.log "message", topic, message.toString()
  do client.end

module.exports = client