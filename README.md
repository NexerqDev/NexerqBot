NexerqBot
============

Another one of those twitch.tv bots that work pretty much the same to all the other ones out there.

Except this time it's written in CoffeeScript (which some others may have too).


## Development setup
```
$ git clone https://github.com/nicholastay/NexerqBot && cd NexerqBot # or fork it and clone from your repo
$ cp config/config.coffee.template config/config.coffee
$ cp config/sequelize.json.template config/sequelize.json
$ nano config/config.coffee # The actual bot config stuff
$ nano config/sequelize.json # Postgres DB config stuff
$ npm install # Get deps
$ npm run migrate # Run DB migrations
$ npm start # Launch the bot itself
```
(yes it's so very long)