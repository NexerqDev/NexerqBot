# Global command handling

class module.exports
    constructor: (@NexerqBot) ->
        @NexerqBot.Events.on 'twitch.chat', (channel, user, message) => 
            if message is @NexerqBot.Config.modules.global.commandprefix
                @NexerqBot.Clients.Twitch.say channel, 'hi. i work.'

    defaultConfig:
        commandprefix: '!nb'