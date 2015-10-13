colors = require 'colors'
strftime = require 'strftime'

# Some functions to output to the console with color
class module.exports
    constructor: (@NexerqBot) ->

    log: (modulename, type, message) ->
        console.log "#{strftime '[%l:%M%P]'}".cyan, "[#{modulename}]".magenta, "#{type}:".reset, "#{message}".reset

    logNoType: (modulename, message) ->
        console.log "#{strftime '[%l:%M%P]'}".cyan, "[#{modulename}]".magenta, "#{message}".reset

    info: (modulename, message) =>
        @log modulename, 'info'.green, message

    error: (modulename, message) =>
        @log modulename, 'ERROR'.red, message

    warn: (modulename, message) =>
        @log modulename, 'warn'.yellow, message

    success: (modulename, message) =>
        @log modulename, 'SUCCESS'.green, message

    fail: (modulename, message) =>
        @log modulename, 'FAIL'.red, message

    fatal: (modulename, message) =>
        @log modulename, 'FATAL'.red, message
        process.exit 1