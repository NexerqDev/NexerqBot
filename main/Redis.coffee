redis = require 'redis'

class module.exports
    constructor: (@NexerqBot) ->

    defaultConfig:
        host: '127.0.0.1'
        port: 6379
    
    init: ->
        @client = redis.createClient @NexerqBot.Config.redis.port, @NexerqBot.Config.redis.host
        @client.on 'connect', => @NexerqBot.Logging.success 'RedisDB', 'Connected to Redis database.'

    setAsync: (module, key, value, cb) ->
        @NexerqBot.Logging.info 'RedisDB', "Attempting to add #{module}'s #{key}..."
        @client.set "NexerqBot>#{module}_#{key}", value, cb

    getAsync: (module, key, cb) -> 
        @client.get "NexerqBot>#{module}_#{key}", cb

    deleteAsync: (module, key, cb) ->
        @NexerqBot.Logging.info 'RedisDB', "Attempting to delete #{module}'s #{key}..."
        @client.del "NexerqBot>#{module}_#{key}", cb

    keyExistsAsync: (module, key, cb) ->
        @client.exists "NexerqBot>#{module}_#{key}", (err, reply) =>
            if reply is 1 then return cb null, true
            cb 'Not exist.'