# README

The aim of this project is to build a parser for a log file.

`parser.log` is generated by quake 3 arena server. All information is recorded, when a game starts, when it ends,
who killed, who was killed, who was killed because fell into the void, who was injured, etc.

The parser must be able to read a file, group game data, gather information about the player's items in each game.

Considering the provided log, assume the following rules:

Items are cumulative, but each item is logged in a specific entry, in other words, when a player takes 3 units of the same item,
the log must display 3 consecutive records of the same item for the same player.

Every item disappear after 3 minutes!

When dying, the dying player transfers all his items to the killer.

At the end of the game, which items does every player have?

### Ruby version
2.6.2

### Setup
Add this line to your application's Gemfile:

```ruby
gem 'parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parser

## Usage

```ruby
require 'parser'

parser = Parser::QuakeParser.new
parser.from_file(file_path)

# Will return the inventory summary for all games
parser.games_summary
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
