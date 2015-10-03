# Global command handling

class module.exports
    constructor: (@NexerqBot) ->
        @NexerqBot.Events.on 'twitch.chat', (data) => 
            if data.message.split(' ')[0] is @NexerqBot.Config.bot.modules.global.commandprefix
                @NexerqBot.Clients.twitch.say data.channel, 'hi. i work.'