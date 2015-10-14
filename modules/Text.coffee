# Text commands, mods and broadcaster can create, remove and modify them.
Module = require '../models/Module'

class module.exports extends Module
    onBotReady: ->
        @commands = {}
        @cacheCommandsFromDB()

    onCommand: (channel, user, command, tail) ->
        @checkForUserCommands channel, user, command

    onGlobalCommand: (channel, user, command, tail) ->
        @checkForModCommands channel, user, command, tail

    cacheCommandsFromDB: ->
        @commands = {}
        for channel in @NexerqBot.Config.twitch.chat.channels
            clean = channel.replace '#', ''
            @commands[clean] = []
            
        @NexerqBot.Database.Model.commands.findAll
            attributes: ['channel', 'command']
        .then (commands) =>
            for data in commands
                @commands[data.channel].push data.command

    checkForUserCommands: (channel, user, command) ->
        cleanChannel = channel.replace '#', ''
        if @commands[cleanChannel]
            if command in @commands[cleanChannel]
                @NexerqBot.Database.Model.commands.findOne
                    where:
                        channel: cleanChannel
                        command: command
                    attributes: ['output']
                .then (dbResp) =>
                    @NexerqBot.Twitch.say channel, dbResp.output

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

    checkForModCommands: (channel, user, command, tail) ->
        cleanChannel = channel.replace '#', ''
        tail = tail.split ' '
        return if not @NexerqBot.Modules.User.isChatMod cleanChannel, user
        return if command isnt 'command' and not tail[0] and not tail[1]

        # Command: 'command'
        # tail[0]: 'add' or 'remove'
        # tail[1]: command itself
        # tail[2]: command output

        switch tail[0]
            when 'add'
                # Add command
                break if not tail[2]
                if tail[1] in @commands[cleanChannel]
                    @NexerqBot.Twitch.say channel, 'The command you are trying to add already exists. Nothing has been changed.'
                else
                    @addChannelCommand cleanChannel, tail[1], tail[2], user.username
                    .then =>
                        @cacheCommandsFromDB()
                        @NexerqBot.Twitch.say channel, 'Command was added to the channel\'s command set.'
                break
            when 'remove'
                # Remove command
                if tail[1] not in @commands[cleanChannel]
                    @NexerqBot.Twitch.say channel, 'The command you are trying to remove does not exist. Nothing has been changed.'
                else
                    @removeChannelCommand cleanChannel, tail[1]
                    .then =>
                        @cacheCommandsFromDB()
                        @NexerqBot.Twitch.say channel, 'Command was removed from the channel\'s command set.'
