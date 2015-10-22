redis = require 'redis'

class module.exports
    constructor: (@NexerqBot) ->

    defaultConfig:
        host: '127.0.0.1'
        port: 6379
    
    init: ->
        @client = @NexerqBot.Clients.Redis = redis.createClient @NexerqBot.Config.redis.port, @NexerqBot.Config.redis.host
        @client.on 'connect', => @NexerqBot.Logging.success 'RedisDB', 'Connected to Redis database.'

    setAsync: (module, key, value, cb) ->
        @NexerqBot.Logging.info 'RedisDB', "Attempting to add #{module}'s #{key}..."
        @client.set "NexerqBot:#{module}:#{key}", value, cb

    getAsync: (module, key, cb) -> 
        @client.get "NexerqBot:#{module}:#{key}", cb

    deleteAsync: (module, key, cb) ->
        @NexerqBot.Logging.info 'RedisDB', "Attempting to delete #{module}'s #{key}..."
        @client.del "NexerqBot:#{module}:#{key}", cb

    pushAsync: (module, key, value, cb) ->
        @NexerqBot.Logging.info 'RedisDB', "Attempting to push to #{module}'s #{key}..."
        @client.lpush "NexerqBot:#{module}:#{key}", value, cb

    keyExistsAsync: (module, key, cb) ->
        @client.exists "NexerqBot:#{module}:#{key}", (err, reply) =>
            if reply is 1 then return cb null, true
            cb 'Not exist.'

    listGetAsync: (module, key, cb) ->
        # Get a list (https://groups.google.com/forum/#!topic/nodejs/qQf5bGkAi90)
        # Get the first index to the last index basically
        @client.lrange "NexerqBot:#{module}:#{key}", 0, -1, cb

    incrAsync: (module, key, cb) -> @client.incr "NexerqBot:#{module}:#{key}", cb