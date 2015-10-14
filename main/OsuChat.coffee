Osu = require 'nodesu'
colors = require 'colors'

class module.exports
    constructor: (@NexerqBot) ->

    defaultConfig:
        login:
            username: 'Nexerq'
            password: 'https://osu.ppy.sh/p/irc'

    connect: ->
        @client = @NexerqBot.Clients.OsuChat = new Osu.chat
            username: @NexerqBot.Config.osuchat.login.username
            password: @NexerqBot.Config.osuchat.login.password
            
        @client.on 'connected', =>
            @NexerqBot.Logging.info 'osu! Chat', 'Connected to osu!bancho IRC.'

        @client.on 'error', (message) =>
            @NexerqBot.Logging.error 'osu! Chat', 'osu! client error: ' + message

        @client.on 'pm', (from, message) =>
            @NexerqBot.Logging.logNoType 'osu! Chat', "#{colors.yellow "#{from} -> #{@NexerqBot.Config.osuchat.login.username}"} #{message}"
            @NexerqBot.Events.emit 'osu.message', from, message

        @client.connect()

    say: (to, message) -> 
        try
            @client.client.say to, message
        catch e
            return @NexerqBot.Logging.warn 'osu! Chat', 'osu! chat client is not connected, no message was sent.'
        @NexerqBot.Logging.logNoType 'osu! Chat', "#{colors.yellow "#{@NexerqBot.Config.osuchat.login.username} -> #{to}"} #{message}"