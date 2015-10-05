color = require '../other/terminalcolor'
strftime = require 'strftime'

# Some functions to output to the console with color
class module.exports
    constructor: (@NexerqBot) ->

    log: (modulename, type, message) ->
        console.log "#{color.foregroundCyan}#{strftime '[%l:%M%P]'} #{color.foregroundMagenta}[#{modulename}] #{color.formatReset}#{type}: #{color.formatReset}#{message}"

    info: (modulename, message) =>
        @log modulename, "#{color.foregroundGreen}info", message

    error: (modulename, message) =>
        @log modulename, "#{color.foregroundRed}error", message

    warn: (modulename, message) =>
        @log modulename, "#{color.foregroundYellow}warn", message

    success: (modulename, message) =>
        @log modulename, "#{color.foregroundGreen}success", message

    fail: (modulename, message) =>
        @log modulename, "#{color.foregroundRed}fail", message