# Text commands, mods and broadcaster can create, remove and modify them.

class module.exports
    constructor: (@NexerqBot) ->
        @NexerqBot.Events.on 'bot.ready', =>
            @commands = {}
            @cacheCommandsFromDB()

        @NexerqBot.Events.on 'twitch.chat', (channel, user, message) => 
            @checkForUserCommands channel, user, message
            @checkForModCommands channel, user, message

    cacheCommandsFromDB: ->
        @commands = {}
        @NexerqBot.Database.Model.commands.findAll
            attributes: ['channel', 'command']
        .then (commands) =>
            for data in commands
                if not @commands[data.channel]
                    @commands[data.channel] = []
                @commands[data.channel].push data.command

    checkForUserCommands: (channel, user, message) ->
        cleanChannel = channel.replace('#', '')
        command = message.split(' ')[0]
        if @commands[cleanChannel]
            if command in @commands[cleanChannel]
                @NexerqBot.Database.Model.commands.findOne
                    where:
                        channel: cleanChannel
                        command: command
                    attributes: ['output']
                .then (dbResp) =>
                    @NexerqBot.Clients.Twitch.say channel, dbResp.output

    addChannelCommand: (channel, command, output, username) ->
        return @NexerqBot.Database.Model.commands.create
            channel: channel
            command: command
            output: output
            addedBy: username

    removeChannelCommand: (channel, command) ->
        return @NexerqBot.Database.Model.commands.destroy
            where:
                channel: channel
                command: command

    checkForModCommands: (channel, user, message) ->
        cleanChannel = channel.replace('#', '')
        command = message.split(' ')
        return if command[0] isnt @NexerqBot.Config.modules.global.commandprefix
        return if not @NexerqBot.Modules.User.isChatMod(cleanChannel, user)
        return if not command[1] is 'command' and not command[2] and not command[3] # command[2] and [3] make sure third and fourth params arent falsy; command[3] is the command
        switch command[2]
            when 'add'
                # Add command
                break if not command[4]
                if command[3] in @commands[cleanChannel]
                    @NexerqBot.Clients.Twitch.say channel, 'The command you are trying to add already exists. Nothing has been changed.'
                else
                    @addChannelCommand cleanChannel, command[3], command[4], user.username
                    .then =>
                        @cacheCommandsFromDB()
                        @NexerqBot.Clients.Twitch.say channel, 'Command was added to the channel\'s command set.'
                break
            when 'remove'
                if command[3] not in @commands[cleanChannel]
                    @NexerqBot.Clients.Twitch.say channel, 'The command you are trying to remove does not exist. Nothing has been changed.'
                else
                    @removeChannelCommand cleanChannel, command[3]
                    .then =>
                        @cacheCommandsFromDB()
                        @NexerqBot.Clients.Twitch.say channel, 'Command was removed from the channel\'s command set.'
