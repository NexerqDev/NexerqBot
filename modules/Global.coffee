# Global command handling
Module = require '../models/Module'

class module.exports extends Module
    defaultConfig:
        commandprefix: '!nb'

    onGlobalCommand: (channel, user, command, tail) -> @NexerqBot.Twitch.say channel, 'Hi! I\'m NexerqBot, developed by Nexerq (n2468txd). Don\'t ask how to use me, don\'t ask Nexerq either.' if not command