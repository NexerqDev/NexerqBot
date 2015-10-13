CSON = require 'CSON'
fs = require 'fs'

class module.exports
    constructor: (@NexerqBot) ->

    load: ->
        config = fs.readFileSync './config/config.cson'
        #return @NexerqBot.Logging.error 'ConfigIO', 'Config load fail! Please fix your config/config.cson file up.' if err
        @NexerqBot.Config = CSON.parse config
        @NexerqBot.Logging.success 'ConfigIO', 'Config successfully loaded into memory!'