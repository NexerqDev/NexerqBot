nesh = require 'nesh'
fs = require 'fs'
events = require 'events'
path = require 'path'

class NexerqBotClass
    constructor: ->
        @Config = {}
        @Clients = {}
        @Main = {}
        @Modules = {}
        @Events = new events.EventEmitter()


NexerqBot = new NexerqBotClass

# Nesh REPL Server
nesh.config.load()
nesh.loadLanguage 'coffee'
# Get welcome ver from package json
packagedata = JSON.parse fs.readFileSync './package.json', 'utf8'
nesh.start
    welcome: "NexerqBot v#{packagedata.version} 2015"
    prompt: 'NexerqBot » '
    useGlobal: true,
    (err, repl) ->
        nesh.log.error err if err
        repl.context.NexerqBot = NexerqBot
console.log '\n'


# Load the main client modules (for files in ./main)
for mod in fs.readdirSync './main'
    continue if path.extname mod isnt '.coffee'
    modName = mod.replace '.coffee', ''
    mod = require "./main/#{modName}"
    NexerqBot[modName] = new mod NexerqBot


# Load config and load DB ready for modules
NexerqBot.ConfigIO.load()
NexerqBot.Database.init()


# Load modules (chat handlers, etc) [for files in ./modules]
for mod in fs.readdirSync './modules'
    continue if path.extname mod isnt '.coffee'
    modName = mod.replace '.coffee', ''
    mod = require "./modules/#{modName}"
    NexerqBot.Modules[modName] = new mod NexerqBot


# Connect clients and init clients
NexerqBot.Twitch.connect()
NexerqBot.OsuChat.connect()
NexerqBot.OsuApi.init()