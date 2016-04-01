# wit-ruby

`wit-ruby` is a Ruby client to easily use the [Wit.ai](http://wit.ai) HTTP API.

## Install

```bash
gem install wit
```

## Usage

```ruby
require 'wit'
p Wit.message('MY_ACCESS_TOKEN', 'turn on the lights in the kitchen')
```

See below for more examples.

## Install from source

```bash
git clone https://github.com/wit-ai/wit-ruby
gem build wit.gemspec
gem install wit-*.gem
```

## API

```ruby
require 'wit'

access_token = 'MY_ACCESS_TOKEN'

# GET /message to extract intent and entities from user request
p Wit.message(access_token, 'turn on the lights in the kitchen')
```

## Thanks

Thanks to [Justin Workman](http://github.com/xtagon) for releasing a first version in October 2013. We really appreciate!
