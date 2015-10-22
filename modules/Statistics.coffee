Module = require '../models/Module'

class module.exports extends Module
    onMessage: -> @NexerqBot.Redis.incrAsync 'statistics', 'messages_handled'
    onWhisper: -> @NexerqBot.Redis.incrAsync 'statistics', 'whispers_handled'