Twitch = require 'tmi.js'

class module.exports
    constructor: (@NexerqBot) ->
        @client = null

    connect: =>
        @client = new Twitch.client
            options:
                debug: @NexerqBot.config.debug
            connection:
                random: 'chat'
                reconnect: true
            identity:
                username: @NexerqBot.config.twitch.chat.login.username
                password: @NexerqBot.config.twitch.chat.login.password
            channels: []

        @client.connect()