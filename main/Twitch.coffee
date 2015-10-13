Twitch = require 'tmi.js'
colors = require 'colors'

class module.exports
    constructor: (@NexerqBot) ->

    defaultConfig:
        chat:
            login:
                username: 'NexerqBot'
                password: 'oauth:'
            channels: ['#channel']

    connect: ->
        client = @NexerqBot.Clients.Twitch = new Twitch.client
            options:
                debug: false
            connection:
                random: 'chat'
                reconnect: true
            identity:
                username: @NexerqBot.Config.twitch.chat.login.username
                password: @NexerqBot.Config.twitch.chat.login.password
            channels: @NexerqBot.Config.twitch.chat.channels

        # Set up events
        client.on 'chat', (channel, user, message) =>
            @NexerqBot.Logging.logNoType 'Twitch Chat', "#{colors.yellow channel} #{colors.green user['display-name']}: #{message}"
            @NexerqBot.Events.emit 'twitch.chat', channel, user, message

        client.on 'action', (channel, user, message) =>
            @NexerqBot.Logging.logNoType 'Twitch Chat', "#{colors.yellow channel} #{colors.green "* #{user['display-name']} #{message}"}"
            @NexerqBot.Events.emit 'twitch.action', channel, user, message

        client.on 'connected', =>
            @NexerqBot.Logging.info 'Twitch Chat', 'Connected to twitch chat servers.'
            @NexerqBot.Events.emit 'twitch.connected'

        client.connect()