Osu = require 'nodesu'

class module.exports
    constructor: (@NexerqBot) ->
        @client = @NexerqBot.Clients.OsuApi = new Osu.api
            apiKey: @NexerqBot.Config.osu.api.key