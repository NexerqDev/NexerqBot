# A 'model'/template that classes can extend

class module.exports
    constructor: (@NexerqBot) ->
        # Run init if exists
        @init() if typeof @init is 'function'

        @NexerqBot.Events.on 'twitch.chat', (channel, user, message) =>
            splitMessage = message.split ' '

            # Basic onmessage
            @onMessage channel, user, message if typeof @onMessage is 'function'

            # Basic oncommand first term
            @onCommand channel, user, splitMessage[0], splitMessage.slice(1).join(' ') if typeof @onCommand is 'function'

            # Basic splitmessage
            if splitMessage[0] is @NexerqBot.Config.modules.global.commandprefix
                @onGlobalCommand channel, user, splitMessage[1], splitMessage.slice(2).join(' ') if typeof @onGlobalCommand is 'function'

        @NexerqBot.Events.on 'bot.ready', => @onBotReady() if typeof @onBotReady is 'function'