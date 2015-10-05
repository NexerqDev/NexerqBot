Twitch = require 'tmi.js'

class module.exports
    constructor: (@NexerqBot) ->

    connect: =>
        client = @NexerqBot.Clients.Twitch = new Twitch.client
            options:
                debug: @NexerqBot.Config.twitch.debug
            connection:
                random: 'chat'
                reconnect: true
            identity:
                username: @NexerqBot.Config.twitch.chat.login.username
                password: @NexerqBot.Config.twitch.chat.login.password
            channels: @NexerqBot.Config.twitch.chat.channels

        # Set up events
        client.on 'chat', (channel, user, message) =>
            @NexerqBot.Events.emit('twitch.chat', {channel: channel, user: user, message: message})

        client.on 'action', (channel, user, message) =>
            @NexerqBot.Events.emit('twitch.action', {channel: channel, user: user, message: message})

        client.on 'connected', =>
            @NexerqBot.Logging.info 'Twitch Chat', 'Connected to twitch chat servers.'

        client.connect()