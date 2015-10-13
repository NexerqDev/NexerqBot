NexerqBot
============

Another one of those twitch.tv bots that work pretty much the same to all the other ones out there.

Except this time it's written in CoffeeScript (which some others may have too).


## Development setup
```
$ git clone https://github.com/nicholastay/NexerqBot && cd NexerqBot # or fork it and clone from your repo
$ npm install # Get deps
$ npm start # Initial launch to generate config (or use template if this fails badly)
$ vim config/config.cson # Edit the config
$ npm run migrate # Run DB migrations (ensure db config is in config.cson properly)
$ npm start # Launch the bot itself
```
(tested on mac, probably would work on linux/unix, npm scripts probably would fail on windows)