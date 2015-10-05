# Global command handling

class module.exports
    constructor: (@NexerqBot) ->
        @NexerqBot.Events.on 'twitch.chat', (data) => 
            if data.message.split(' ')[0] is @NexerqBot.Config.modules.global.commandprefix and not data.message.split(' ')[1]
                @NexerqBot.Clients.Twitch.say data.channel, 'hi. i work.'