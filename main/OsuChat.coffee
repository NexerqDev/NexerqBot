Osu = require 'nodesu'

class module.exports
    constructor: (@NexerqBot) ->
        @client = @NexerqBot.Clients.OsuChat = new Osu.chat
            username: @NexerqBot.Config.osu.chat.login.username
            password: @NexerqBot.Config.osu.chat.login.password

    connect: =>
        @client.on 'connected', =>
            @NexerqBot.Logging.info 'osu! Chat', 'Connected to osu!bancho IRC.'

        @client.on 'error', (data) =>
            @NexerqBot.Logging.log 'osu! Chat', 'osu! client error: ' + data.message

        @client.on 'pm', (data) =>
            @NexerqBot.Events.emit('osu.message', data)

        @client.connect()