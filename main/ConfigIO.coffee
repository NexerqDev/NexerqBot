CSON = require 'CSON'
fs = require 'fs'

class module.exports
    constructor: (@NexerqBot) ->

    load: ->
        try
            config = fs.readFileSync './config/config.cson'
        catch
            return @NexerqBot.Logging.fatal 'ConfigIO', 'Config load fail! Please fix your config/config.cson file up.'

        try
            @NexerqBot.Config = CSON.parse config
        catch
            return @NexerqBot.Logging.fatal 'ConfigIO', 'Failed to parse config file! Please vaildate your CSON and try again.'

        @NexerqBot.Logging.success 'ConfigIO', 'Config successfully loaded into memory!'

    write: -> 
        try
            fs.writeFileSync './config/config.cson', CSON.stringify @NexerqBot.Config
        catch
            return @NexerqBot.Logging.fatal 'ConfigIO', 'There was an error writing the config to disk. Please make sure your permission settings are set correctly for this bot.'