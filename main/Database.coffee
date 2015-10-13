fs = require 'fs'
path = require 'path'
xtend = require 'xtend'
colors = require 'colors'
Sequelize = require 'sequelize'

class module.exports
    constructor: (@NexerqBot) ->

    defaultConfig:
        username: 'postgres'
        password: 'postgres'
        database: 'nexerqbot'
        host: '127.0.0.1'
        dialect: 'postgres'
    
    init: ->
        db = {}

        config =
            logging: (str) ->
                msg = str.split ':'
                return @NexerqBot.Logging.logNoType 'Database', "#{msg[0].yellow}:#{msg[1]}" if msg[1]
                @NexerqBot.Logging.logNoType 'Database', str.yellow

            dialect: 'postgres'
            host: '127.0.0.1'
        config = xtend config, @NexerqBot.Config.database

        # Init sequelize
        sequelize = new Sequelize @NexerqBot.Config.database.database, @NexerqBot.Config.database.username, @NexerqBot.Config.database.password, config

        # Load db models
        for modelFile in fs.readdirSync path.resolve __dirname, '../', 'models'
            continue if path.extname modelFile isnt '.coffee'

            # Follow sequelize template style import
            model = sequelize['import'] path.resolve __dirname, '../', 'models', modelFile
            db[model.name] = model

        # db associate (as per sequelize template)
        for key of db
            db[key].associate db if db[key].associate

        db.sequelize = sequelize
        db.Sequelize = Sequelize

        @Model = db