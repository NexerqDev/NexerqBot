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

        @client.on 'error', (data) =>
            @NexerqBot.Logging.error 'osu! Chat', 'osu! client error: ' + data.message

        @client.on 'pm', (data) =>
            @NexerqBot.Logging.logNoType 'osu! Chat', "#{colors.yellow "#{data.from} -> #{@NexerqBot.Config.osuchat.login.username}"} #{data.message}"
            @NexerqBot.Events.emit('osu.message', data)

        @client.connect()