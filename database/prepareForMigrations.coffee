colors = require 'colors'
CSON = require 'CSON'
path = require 'path'
fs = require 'fs'

try
    config = fs.readFileSync path.resolve __dirname, '../', 'config', 'config.cson'
catch e
    if e.code is 'ENOENT'
        console.log 'No config file found, please run main app to generate.'.red
        process.exit 1
    else
        console.log "There was an error reading the config file. (readFileSync err: #{e})".red

config = CSON.parse config

if not config.database
    console.log 'Database configuration not found, please run main app to generate'.red
    process.exit 1

dbConf =
    development: config.database

fileToWrite = path.resolve __dirname, 'sequelize.json'
fs.writeFileSync fileToWrite, JSON.stringify dbConf
console.log 'Sequelize configuration written to sequelize.json, ready to run migrations.'.green