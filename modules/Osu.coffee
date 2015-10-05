osuMapMatch = /osu.ppy.sh\/(s|b)\/(\d+)/i

class module.exports
    constructor: (@NexerqBot) ->
        @NexerqBot.Events.on 'twitch.chat', (data) => 
            @checkForBeatmaps data
    
    checkForBeatmaps: (data) =>
        cleanChannel = data.channel.replace '#', ''
        # Check for beatmap links
        osuMapRegex = osuMapMatch.exec(data.message) # Run the regex
        if osuMapRegex and @NexerqBot.Config.modules.osu.requests.channel[cleanChannel]
            mapType = osuMapRegex[1] # set or beatmap (s/b)
            mapID = osuMapRegex[2]
            @NexerqBot.Clients.OsuApi.getBeatmaps(@NexerqBot.Clients.OsuApi.beatmap.byLetter(mapID, mapType), @NexerqBot.Clients.OsuApi.mode.all, (err, resp) -> 
                if err
                    return @NexerqBot.Logging.error 'osu! Map Requests', "Something went wrong with osu! api. (#{err})"
                if resp is []
                    return # No such map, blank response

                map = resp[0] # First diff in the set
                status = @NexerqBot.Clients.OsuApi.beatmap.approvalStatus[map.approved]
                
                @NexerqBot.Clients.Twitch.say data.channel, "#{data.user['display-name']}: [#{status}] #{map.artist} - #{map.title} [#{map.version}] (mapped by #{map.creator}) <#{map.bpm}BPM #{(+map.difficultyrating).toFixed(2)}★>"
                @NexerqBot.Clients.OsuChat.client.say @NexerqBot.Config.modules.osu.requests.channel[cleanChannel], "#{data.user['display-name']} > [#{status}] [http://osu.ppy.sh/#{mapType}/#{mapID} #{map.artist} - #{map.title} [#{map.version}]] (mapped by #{map.creator}) <#{map.bpm}BPM #{(+map.difficultyrating).toFixed(2)}★>"
            )