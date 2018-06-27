#_ = require "underscore"

class Stuff
  @store: {}
  @loadPromises = {}

  @get: (id, next) ->
    @load id
    .then (stuff) -> next stuff
#
#
#    if @store[id] then next @store[id]
#    else

#      @store[id] = {id: id, name: "загрузка..."}
#      $.ajax {
#        dataType: "json"
#        url: "/db/stuff/" + id + "/json"
#        success: (data) =>
#          console.log "update stuff cache", id, data
#          @store[id] = data
#          next @store[id]
#      }


  @load: (id) ->
    unless @loadPromises[id]
      @loadPromises[id] = new Promise (resolve, reject) =>
        App.message "Загрузка товара" + id
        $.ajax {
          dataType: "json"
          url: "/db/stuff/" + id + "/json"
          success: (data) =>
            console.log "update stuff cache", id, data
            @store[id] = data
            resolve data
          error: =>
            console.error "ошибка загрузки товара"
            @store[id] = no
            reject data
        }
    return @loadPromises[id]

  @clear: (id) -> @loadPromises[id] = null


module.exports = Stuff