class module.exports
    constructor: (@NexerqBot) ->

    isChatMod: (channel, userdata) ->
        if userdata.username is channel
            return true

        if userdata['user-type'] is 'mod'
            return true

        return false