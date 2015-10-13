NexerqBot
============

Another one of those twitch.tv bots that work pretty much the same to all the other ones out there.

Except this time it's written in CoffeeScript (which some others may have too).


## Development setup
```
$ git clone https://github.com/nicholastay/NexerqBot && cd NexerqBot # or fork it and clone from your repo
$ cp config/config.cson.template config/config.cson
$ vi config/config.cson
$ npm install # Get deps
$ npm run migrate # Run DB migrations
$ npm start # Launch the bot itself
```
(yes it's quite long but not too long)