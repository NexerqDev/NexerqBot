CSON = require 'CSON'
fs = require 'fs'
path = require 'path'

class module.exports
    constructor: (@NexerqBot) ->

    load: (cb) ->
        try
            config = fs.readFileSync './config/config.cson'
        catch e
            if e.code is 'ENOENT'
                @NexerqBot.Logging.info 'ConfigIO', 'Config file not found, going to create one to disk.'
                fs.writeFileSync './config/config.cson', ''
            else
                @NexerqBot.Logging.fatal 'ConfigIO', 'Config load fail! Please fix your config/config.cson file up.'

        try
            @NexerqBot.Config = CSON.parse config
        catch
            return @NexerqBot.Logging.fatal 'ConfigIO', 'Failed to parse config file! Please vaildate your CSON and try again.'

        # Create defaults for stuff which need defaults and etc
        newConfigItemsWritten = false
        for modName in @NexerqBot.mainModNames
            if not @NexerqBot.Config[modName.toLowerCase()] and @NexerqBot[modName].defaultConfig
                @NexerqBot.Logging.info 'ConfigIO', "Configuration not found for main module '#{modName}', creating configuration..."
                @NexerqBot.Config[modName.toLowerCase()] = @NexerqBot[modName].defaultConfig
                newConfigItemsWritten = true

        if not @NexerqBot.Config.modules then @NexerqBot.Config.modules = {}

        for modName in Object.keys @NexerqBot.Modules
            if not @NexerqBot.Config.modules[modName.toLowerCase()] and @NexerqBot.Modules[modName].defaultConfig
                @NexerqBot.Logging.info 'ConfigIO', "Configuration not found for handler module '#{modName}', creating configuration..."
                @NexerqBot.Config.modules[modName.toLowerCase()] = @NexerqBot.Modules[modName].defaultConfig
                newConfigItemsWritten = true

        if newConfigItemsWritten
            @write()
            @NexerqBot.Logging.info 'ConfigIO', 'New configuration items have been written, exiting to allow you to make modifications.'
            process.exit()


        @NexerqBot.Logging.success 'ConfigIO', 'Config successfully loaded into memory!'
        cb()

    write: -> 
        try
            fs.writeFileSync './config/config.cson', CSON.stringify @NexerqBot.Config
        catch
            return @NexerqBot.Logging.fatal 'ConfigIO', 'There was an error writing the config to disk. Please make sure your permission settings are set correctly for this bot.'