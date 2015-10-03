# Text commands, user can create, remove and modify them.
dbModels = require '../models'

class module.exports
    constructor: (@NexerqBot) ->
        @commands = {}
        @loadCommandsFromDB()

        @NexerqBot.Events.on 'twitch.chat', (data) => 
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
                        @NexerqBot.Clients.twitch.say data.channel, dbResp.output

    loadCommandsFromDB: =>
        dbModels.commands.findAll
            attributes: ['channel', 'command']
        .then (commands) =>
            for data in commands
                if not @commands[data.channel]
                    @commands[data.channel] = []
                @commands[data.channel].push data.command