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

# Load config
config = require './config/config'
NexerqBot.Config = config

# Load the main client modules (for files in ./main)
for mod in fs.readdirSync './main'
    if path.extname(mod) is not '.coffee'
        continue

    modName = mod.replace '.coffee', ''

    if modName in NexerqBot.Config.disabled.main
        continue

    mod = require "./main/#{modName}"
    NexerqBot[modName] = new mod NexerqBot
    # Try to connect to clients
    try
        NexerqBot[modName].connect()
    catch e
        # Not all main modules have connect() so w/e
        

# Load modules (chat handlers, etc) [for files in ./modules]
for mod in fs.readdirSync './modules'
    if path.extname(mod) is not '.coffee'
        continue

    modName = mod.replace('.coffee', '')

    if modName in NexerqBot.Config.disabled.modules
        continue

    mod = require "./modules/#{modName}"
    NexerqBot.Modules[modName] = new mod NexerqBot


# Nesh REPL Server
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
console.log '\n'