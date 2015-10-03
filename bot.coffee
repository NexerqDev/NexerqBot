repl = require 'repl'
events = require 'events'

class NexerqBotClass
    constructor: ->
        @Config = {}
        @Modules = {}
        @Events = new events.EventEmitter()


NexerqBot = new NexerqBotClass

config = require './config/config'
NexerqBot.Config = config

twitch = require './main/twitch'
NexerqBot.twitch = new twitch NexerqBot

global = require './modules/global'
NexerqBot.Modules.global = new global NexerqBot

# Connect
NexerqBot.twitch.connect()

# REPL Server
replServer = repl.start
    prompt: 'NexerqBot » '
replServer.context.nb = NexerqBot