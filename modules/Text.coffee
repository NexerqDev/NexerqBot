# Text commands, mods and broadcaster can create, remove and modify them.
Module = require '../models/Module'

class module.exports extends Module
    onCommand: (channel, user, command, tail) -> @checkForUserCommands channel, user, command

    onGlobalCommand: (channel, user, command, tail) -> @checkForModCommands channel, user, command, tail

    addChannelCommand: (channel, command, output, cb) -> @NexerqBot.Redis.setAsync 'commands', "#{channel}:#{command}", output, cb

    removeChannelCommand: (channel, command) -> @NexerqBot.Redis.deleteAsync 'commands', "#{channel}:#{command}", cb

    checkForUserCommands: (channel, user, command) ->
        cleanChannel = channel.replace '#', ''
        @NexerqBot.Redis.getAsync 'commands', "#{cleanChannel}:#{command}", (err, reply) =>
            return if err
            return if not reply
            @NexerqBot.Twitch.say channel, reply.toString()

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
                @NexerqBot.Redis.keyExistsAsync 'commands', "#{cleanChannel}:#{tail[1]}", (err, reply) =>
                    if err
                        # Command not exist, make it
                        @addChannelCommand cleanChannel, tail[1], tail[2], =>
                            @NexerqBot.Twitch.say channel, 'Command was (probably) added to the channel\'s command set.'
                    else
                        @NexerqBot.Twitch.say channel, 'The command you are trying to add already exists. Nothing has been changed.'
                break
            when 'remove'
                # Remove command
                @NexerqBot.Redis.keyExistsAsync 'commands', "#{cleanChannel}:#{tail[1]}", (err, reply) =>
                    if err
                        @NexerqBot.Twitch.say channel, 'The command you are trying to remove does not exist. Nothing has been changed.'
                    else
                        # Command exist, delete it
                        @removeChannelCommand cleanChannel, tail[1], =>
                            @NexerqBot.Twitch.say channel, 'Command was (probably) removed from the channel\'s command set.'
                    
