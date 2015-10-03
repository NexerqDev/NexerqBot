repl = require 'repl'

class NexerqBot
    constructor: ->
        @config = {}
        @clients = {}


bot = new NexerqBot

config = require './config/config'
bot.config = config

twitch = require './main/twitch'
bot.twitch = new twitch bot

# Connect
bot.twitch.connect()

# REPL Server
replServer = repl.start
    prompt: 'NexerqBot » '
replServer.context.nb = bot