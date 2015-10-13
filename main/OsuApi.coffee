Osu = require 'nodesu'

class module.exports
    constructor: (@NexerqBot) ->

    defaultConfig:
        key: 'https://osu.ppy.sh/api'
        
    init: ->
        @client = @NexerqBot.Clients.OsuApi = new Osu.api
            apiKey: @NexerqBot.Config.osu.api.key