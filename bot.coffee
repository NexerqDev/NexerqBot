nesh = require 'nesh'
fs = require 'fs'
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
nesh.config.load()
nesh.loadLanguage 'coffee'
# Get welcome ver from package json
packagedata = JSON.parse fs.readFileSync './package.json', 'utf8'
nesh.start
    welcome: "NexerqBot v#{packagedata.version} 2015 (twitch username: #{config.twitch.chat.login.username})"
    prompt: 'NexerqBot » '
    useGlobal: true,
    (err, repl) ->
        nesh.log.error err if err
        repl.context.NexerqBot = NexerqBot