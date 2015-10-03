repl = require 'repl'
events = require 'events'

class NexerqBot
    constructor: ->
        @Config = {}
        @Modules = {}
        @Events = new events.EventEmitter()


bot = new NexerqBot

config = require './config/config'
bot.Config = config

twitch = require './main/twitch'
bot.twitch = new twitch bot

global = require './modules/global'
bot.Modules.global = new global bot

# Connect
bot.twitch.connect()

# REPL Server
replServer = repl.start
    prompt: 'NexerqBot » '
replServer.context.nb = bot