# A 'model'/template that classes can extend

class module.exports
    constructor: (@NexerqBot) ->
        # Run init if exists
        @init() if typeof @init is 'function'

        if typeof @onMessage is 'function'
            @NexerqBot.Events.on 'twitch.chat', (channel, user, message) => @onMessage channel, user, message

        if typeof @onCommand is 'function'
            @NexerqBot.Events.on 'twitch.chat', (channel, user, message) => 
                splitMessage = message.split ' '
                # Basic oncommand first term
                @onCommand channel, user, splitMessage[0], splitMessage.slice(1).join(' ') if typeof @onCommand is 'function'

        if typeof @onGlobalCommand is 'function'
            @NexerqBot.Events.on 'twitch.chat', (channel, user, message) =>
                splitMessage = message.split ' '
                if splitMessage[0] is @NexerqBot.Config.modules.global.commandprefix
                    @onGlobalCommand channel, user, splitMessage[1], splitMessage.slice(2).join(' ') if typeof @onGlobalCommand is 'function'

        @NexerqBot.Events.on 'twitchwhisp.whisper', (from, message) => @onWhisper from, message if typeof @onWhisper is 'function'

        @NexerqBot.Events.on 'bot.ready', => @onBotReady() if typeof @onBotReady is 'function'