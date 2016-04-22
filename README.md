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

## API

### Overview

`wit-ruby` provides a Wit class with the following methods:
* `message` - the Wit [message API](https://wit.ai/docs/http/20160330#get-intent-via-text-link)
* `converse` - the low-level Wit [converse API](https://wit.ai/docs/http/20160330#converse-link)
* `run_actions` - a higher-level method to the Wit converse API

### Wit class

The Wit constructor takes the following parameters:
* `access_token` - the access token of your Wit instance
* `actions` - the `Hash` with your actions

The `actions` `Hash` has action names as keys, and action implementations as values.
Action names are symbols, and action implementations are lambda functions (not `Proc`).
You need to provide at least an implementation for the special actions `:say`, `:merge` and `:error`.

A minimal `actions` `Hash` looks like this:
```ruby
actions = {
  :say => -> (session_id, context, msg) {
    p msg
  },
  :merge => -> (session_id, context, entities, msg) {
    return context
  },
  :error => -> (session_id, context, error) {
    p error.message
  },
}
```

A custom action takes the following parameters:
* `session_id` - a unique identifier describing the user session
* `context` - the `Hash` representing the session state

Example:
```ruby
require 'wit'
client = Wit.new access_token, actions
```

### Logging

Default logging is to `STDOUT` with `INFO` level.

You can setup your logging level as follows:
```ruby
Wit.logger.level = Logger::WARN
```
See the [Logger class](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html) docs for more information.

### message

The Wit [message API](https://wit.ai/docs/http/20160330#get-intent-via-text-link).

Takes the following parameters:
* `msg` - the text you want Wit.ai to extract the information from

Example:
```ruby
resp = client.message 'what is the weather in London?'
p "Yay, got Wit.ai response: #{resp}"
```

### run_actions

A higher-level method to the Wit converse API.

Takes the following parameters:
* `session_id` - a unique identifier describing the user session
* `message` - the text received from the user
* `context` - the `Hash` representing the session state
* `max_steps` - (optional) the maximum number of actions to execute (defaults to 5)

Example:
```ruby
session = 'my-user-session-42'
context0 = {}
context1 = client.run_actions session, 'what is the weather in London?', context0
p "The session state is now: #{context1}"
context2 = client.run_actions session, 'and in Brussels?', context1
p "The session state is now: #{context2}"
```

### converse

The low-level Wit [converse API](https://wit.ai/docs/http/20160330#converse-link).

Takes the following parameters:
* `session_id` - a unique identifier describing the user session
* `msg` - the text received from the user
* `context` - the `Hash` representing the session state

Example:
```ruby
resp = client.converse 'my-user-session-42', 'what is the weather in London?', {}
p "Yay, got Wit.ai response: #{resp}"
```


See the [docs](https://wit.ai/docs) for more information.

### Callbacks

Support custom callbacks upon receiving responses from the message and converse APIs. These default to logging them at debug level. This can also be overwritten.

Example:
```ruby
Wit.on_converse_response = ->(res) { puts "Converse confidence: #{res['confidence']}" }
```

## Thanks

Thanks to [Justin Workman](http://github.com/xtagon) for releasing a first version in October 2013. We really appreciate!
