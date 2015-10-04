# Text commands, mods and broadcaster can create, remove and modify them.
dbModels = require '../models'

class module.exports
    constructor: (@NexerqBot) ->
        @commands = {}
        @cacheCommandsFromDB()

        @NexerqBot.Events.on 'twitch.chat', (data) => 
            @checkForUserCommands(data)
            @checkForModCommands(data)

    cacheCommandsFromDB: =>
        @commands = {}
        dbModels.commands.findAll
            attributes: ['channel', 'command']
        .then (commands) =>
            for data in commands
                if not @commands[data.channel]
                    @commands[data.channel] = []
                @commands[data.channel].push data.command

    checkForUserCommands: (data) =>
        cleanChannel = data.channel.replace('#', '')
        command = data.message.split(' ')[0]
        if @commands[cleanChannel]
            if command in @commands[cleanChannel]
                dbModels.commands.findOne
                    where:
                        channel: cleanChannel
                        command: command
                    attributes: ['output']
                .then (dbResp) =>
                    @NexerqBot.Clients.Twitch.say data.channel, dbResp.output

    addChannelCommand: (channel, command, output, username) =>
        return dbModels.commands.create
            channel: channel
            command: command
            output: output
            addedBy: username

    removeChannelCommand: (channel, command) =>
        return dbModels.commands.destroy
            where:
                channel: channel
                command: command

    checkForModCommands: (data) =>
        cleanChannel = data.channel.replace('#', '')
        command = data.message.split(' ')
        if command[0] is @NexerqBot.Config.bot.modules.global.commandprefix
            if @NexerqBot.Main.User.isChatMod(cleanChannel, data.user)
                if command[1] is 'command' and command[2] and command[3] # command[2] and [3] make sure third and fourth params arent falsy; command[3] is the command
                    if command[2] is 'add' and command[4] # Ensure there is an output
                        # Add command
                        if command[3] in @commands[cleanChannel]
                            @NexerqBot.Clients.Twitch.say data.channel, 'The command you are trying to add already exists. Nothing has been changed.'
                        else
                            @addChannelCommand cleanChannel, command[3], command[4], data.user.username
                            .then =>
                                @cacheCommandsFromDB()
                                @NexerqBot.Clients.Twitch.say data.channel, 'Command was added to the channel\'s command set.'
                    else if command[2] is 'remove'
                        if command[3] not in @commands[cleanChannel]
                            @NexerqBot.Clients.Twitch.say data.channel, 'The command you are trying to remove does not exist. Nothing has been changed.'
                        else
                            @removeChannelCommand cleanChannel, command[3]
                            .then =>
                                @cacheCommandsFromDB()
                                @NexerqBot.Clients.Twitch.say data.channel, 'Command was removed from the channel\'s command set.'
