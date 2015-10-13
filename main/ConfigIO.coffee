CSON = require 'CSON'
fs = require 'fs'

class module.exports
    constructor: (@NexerqBot) ->

    load: ->
        try
            config = fs.readFileSync './config/config.cson'
        catch
            return @NexerqBot.Logging.fatal 'ConfigIO', 'Config load fail! Please fix your config/config.cson file up.'
        @NexerqBot.Config = CSON.parse config
        @NexerqBot.Logging.success 'ConfigIO', 'Config successfully loaded into memory!'