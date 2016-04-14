# wit-ruby

`wit-ruby` is the Ruby SDK for [Wit.ai](http://wit.ai).

## Install

From RubyGems:
```bash
gem install wit
```

From source:
```bash
git clone https://github.com/wit-ai/wit-ruby
gem build wit.gemspec
gem install wit-*.gem
```

## Usage

See the `examples` folder for examples.

### Logging

Default logging is to `STDOUT` with `DEBUG` level. Silence logger as follows.

```ruby
Wit.logger.level = Logger::WARN
```

## API

`wit-ruby` provides a Wit class with the following methods:
* `message` - the Wit message API
* `converse` - the low-level Wit converse API
* `run_actions` - a higher-level method to the Wit converse API

See the [docs](https://wit.ai/docs) for more information.

## Thanks

Thanks to [Justin Workman](http://github.com/xtagon) for releasing a first version in October 2013. We really appreciate!
