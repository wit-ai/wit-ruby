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

## Quickstart

Run in your terminal:

```bash
ruby examples/basic.rb <your_token>
```

See the `examples` folder for more examples.

## API

### Overview

`wit-ruby` provides a Wit class with the following methods:
* `message` - the Wit [message API](https://wit.ai/docs/http/20200513#get-intent-via-text-link)
* `interactive` - starts an interactive conversation with your bot

### Wit class

The Wit constructor takes a `Hash` with the following symbol keys:
* `:access_token` - the access token of your Wit instance

A minimal example looks like this:
```ruby
require 'wit'

client = Wit.new(access_token: access_token)
client.message('set an alarm tomorrow at 7am')
```

### .message()

The Wit [message API](https://wit.ai/docs/http/20200513#get-intent-via-text-link).

Takes the following parameters:
* `msg` - the text you want Wit.ai to extract the information from

Example:
```ruby
rsp = client.message('what is the weather in London?')
puts("Yay, got Wit.ai response: #{rsp}")
```

### .interactive()

Starts an interactive conversation with your bot.

Example:
```ruby
client.interactive
```

### CRUD operations for entities
payload in the parameters is a hash containing API arguments

#### .get_entities()
Returns a list of available entities for the app.  
See [GET /entities](https://wit.ai/docs/http/20200513#get--entities-link)

#### .post_entities(payload)
Creates a new entity with the given attributes.  
See [POST /entities](https://wit.ai/docs/http/20200513#post--entities-link)

#### .get_entity(entity_id)
Returns all the information available for an entity.  
See [GET /entities/:entity](https://wit.ai/docs/http/20200513#get--entities-:entity-link)

#### .put_entities(entity_id, payload)
Updates an entity with the given attributes.  
See [PUT /entities/:entity](https://wit.ai/docs/http/20200513#put--entities-:entity-link)

#### .delete_entities(entity_id)
Permanently removes the entity.  
See [DELETE /entities/:entity](https://wit.ai/docs/http/20200513#delete--entities-:entity-link)

#### .post_keywords(entity_id, payload)
Adds a possible value into the list of keywords for the keywords entity.
See [POST /entities/:entity/keywords](https://wit.ai/docs/http/20160526#post--entities-:entity-id-values-link)

#### .delete_keywords(entity_id, keyword)
Deletes a keyword from the entity.  
See [DELETE /entities/:entity/keywords/:keyword](https://wit.ai/docs/http/20200513#delete--entities-:entity-keywords-link)

#### .post_synonyms(entity_id, keyword, payload)
Creates a new synonym for the keyword of the entity.  
See [POST /entities/:entity/keywords/:keyword/synonyms](https://wit.ai/docs/http/20200513#post--entities-:entity-keywords-:keyword-synonyms-link)

#### delete_synonyms(entity_id, keyword, synonym)
Deletes a synonym of the keyword of the entity.  
See [DELETE /entities/:entity/keywords/:keyword/synonyms/:synonym](https://wit.ai/docs/http/20200513#delete--entities-:entity-keywords-:keyword-synonyms-link)

See the [docs](https://wit.ai/docs) for more information.

### Logging

Default logging is to `STDOUT` with `INFO` level.

You can setup your logging level as follows:
```ruby
Wit.logger.level = Logger::WARN
```
See the [Logger class](http://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html) docs for more information.

## Thanks

Thanks to [Justin Workman](http://github.com/xtagon) for releasing a first version in October 2013. We really appreciate!


## License

The license for wit-ruby can be found in LICENSE file in the root directory of this source tree.


## Terms of Use

Our terms of use can be found at https://opensource.facebook.com/legal/terms.


## Privacy Policy

Our privacy policy can be found at https://opensource.facebook.com/legal/privacy.
