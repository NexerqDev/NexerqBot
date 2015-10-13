osuMapMatch = /osu.ppy.sh\/(s|b)\/(\d+)/i

class module.exports
    constructor: (@NexerqBot) ->
        @NexerqBot.Events.on 'twitch.chat', (channel, user, message) => 
            @checkForBeatmaps channel, user, message

    defaultConfig:
        requests:
            channel:
                n2468txd: 'Nexerq'
    
    checkForBeatmaps: (channel, user, message) =>
        cleanChannel = channel.replace '#', ''
        # Check for beatmap links
        osuMapRegex = osuMapMatch.exec(message) # Run the regex
        if osuMapRegex and @NexerqBot.Config.modules.osu.requests.channel[cleanChannel]
            mapType = osuMapRegex[1] # set or beatmap (s/b)
            mapID = osuMapRegex[2]
            @NexerqBot.Clients.OsuApi.getBeatmaps @NexerqBot.Clients.OsuApi.beatmap.byLetter(mapID, mapType), @NexerqBot.Clients.OsuApi.mode.all, (err, resp) -> 
                return @NexerqBot.Logging.error 'osu! Map Requests', "Something went wrong with osu! api. (#{err})" if err
                return if resp is [] # No such map, blank response

                map = resp[0] # First diff in the set
                status = @NexerqBot.Clients.OsuApi.beatmap.approvalStatus[map.approved]
                
                @NexerqBot.Clients.Twitch.say channel, "#{user['display-name']}: [#{status}] #{map.artist} - #{map.title} [#{map.version}] (mapped by #{map.creator}) <#{map.bpm}BPM #{(+map.difficultyrating).toFixed(2)}★>"
                @NexerqBot.Clients.OsuChat.client.say @NexerqBot.Config.modules.osu.requests.channel[cleanChannel], "#{user['display-name']} > [#{status}] [http://osu.ppy.sh/#{mapType}/#{mapID} #{map.artist} - #{map.title} [#{map.version}]] (mapped by #{map.creator}) <#{map.bpm}BPM #{(+map.difficultyrating).toFixed(2)}★>"