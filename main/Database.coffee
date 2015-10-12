fs = require 'fs'
path = require 'path'
Sequelize = require 'sequelize'

class module.exports
    constructor: (@NexerqBot) ->
        db = {}
        # Init sequelize
        sequelize = new Sequelize @NexerqBot.Config.database.database, @NexerqBot.Config.database.username, @NexerqBot.Config.database.password, @NexerqBot.Config.database

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