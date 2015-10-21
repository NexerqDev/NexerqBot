# Module to filter chat messages and timeout them
Module = require '../models/Module'

class module.exports extends Module
    onBotReady: -> @getGlobalCache()
    onMessage: (channel, user, message) -> @checkForFilteredContent channel, user, message
    onGlobalCommand: (channel, user, command, tail) -> @checkForModCommands channel, user, command, tail

    getGlobalCache: ->
        # The global ban on words cache
        @NexerqBot.Redis.listGetAsync 'filter', '_global', (err, reply) =>
            if err or not reply or reply.length is 0
                @NexerqBot.Logging.warn 'Filter', 'Global filters were not able to be loaded! (maybe they don\'t exist...)'
                @globalFilters = []
                return
                
            @globalFilters = reply

    checkForFilteredContent: (channel, user, message) ->
        cleanChannel = channel.replace '#', ''
        @NexerqBot.Redis.listGetAsync 'filter', cleanChannel, (err, reply) =>
            return if err or not reply or reply.length is 0
            for filter in reply
                timeoutIfStringFound filter, user, message
            for filter in @globalFilters
                timeoutIfStringFound filter, user, message
                
    timeoutIfStringFound: (filter, user, message) ->
        filterPattern = new RegExp filter
        if filterPattern.test message
            @NexerqBot.Logging.info 'Filter', "Timing out #{user.username} in #{channel} for unwanted filtered content..."
            @NexerqBot.Twitch.say channel, ".timeout #{user.username} 300"

    checkForModCommands: (channel, user, command, tail) ->
        cleanChannel = channel.replace '#', ''
        tail = tail.split ' '
        return if not @NexerqBot.Modules.User.isChatMod cleanChannel, user
        return if command isnt 'filter' and not tail[0] and not tail[1]

        switch tail[0]
            when 'add'
                # Add filter item
                filterTail = tail.slice(1).join(' ')
                @NexerqBot.Redis.pushAsync 'filter', cleanChannel, filterTail, (err) =>
                    return if err
                    @NexerqBot.Twitch.say channel, 'Filter item was (probably) added to the channel\'s filter list.'
                break
            when 'remove'
                # Remove filter item
                # idk
                console.log 'Remove event here'