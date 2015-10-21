Twitch = require 'tmi.js'
colors = require 'colors'

class module.exports
    constructor: (@NexerqBot) ->

    connect: ->
        @client = @NexerqBot.Clients.TwitchWhisp = new Twitch.client
            options:
                debug: false
            connection:
                server: '192.16.64.180'
                port: 80
                random: 'group'
                reconnect: true
            identity:
                username: @NexerqBot.Config.twitch.chat.login.username
                password: @NexerqBot.Config.twitch.chat.login.password

        # Set up events
        @client.on 'whisper', (username, message) =>
            @NexerqBot.Logging.logNoType 'Twitch Whispers', "#{colors.green username} -> #{colors.green @NexerqBot.Config.twitch.chat.login.username}: #{message}"
            @NexerqBot.Events.emit 'twitchwhisp.whisper', username, message

        @client.on 'connected', =>
            @NexerqBot.Logging.info 'Twitch Whispers', 'Connected to twitch group chat servers (for whispers, duh).'
            @NexerqBot.Events.emit 'twitchwhisp.connected'

        @client.connect()

    whisper: (to, message) -> @client.whisper to, message