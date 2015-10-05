Osu = require 'nodesu'

class module.exports
    constructor: (@NexerqBot) ->
        @client = @NexerqBot.Clients.OsuChat = new Osu.chat
            username: @NexerqBot.Config.osu.chat.login.username
            password: @NexerqBot.Config.osu.chat.login.password

    connect: =>
        @client.on 'connected', =>
          console.log('Connected to osu!bancho IRC.')

        @client.on 'error', (data) =>
          console.log('osu! client error: ' + data.message)

        @client.on 'pm', (data) =>
            @NexerqBot.Events.emit('osu.message', data)

        @client.connect()