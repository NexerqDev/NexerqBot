Osu = require 'nodesu'

class module.exports
    constructor: (@NexerqBot) ->
        
    init: ->
        @client = @NexerqBot.Clients.OsuApi = new Osu.api
            apiKey: @NexerqBot.Config.osu.api.key