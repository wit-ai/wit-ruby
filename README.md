# Wit Ruby SDK

This is the Ruby SDK for [Wit.AI](http://wit.ai).

## Prerequisites

This package requires:

* libsox (`sudo apt-get install libsox2` on Debian, `brew install sox` on OS X)
* a recent Ruby (tested on 2.1.3) - install it via [RVM](http://rvm.io) e.g. `rvm install 2.1.3` with [RubyGems](http://rubygems.org)
* [Cargo](http://crates.io/)

## Installation instructions

### From RubyGems

```bash
gem install wit
```

### From sources

Run the following command into the main directory (where the `wit.gemspec` is located):

```bash
gem build wit.gemspec
gem install wit-1.0.0.gem
```

## Usage

```ruby
require 'wit'

access_token = 'ACCESS_TOKEN'

Wit.init
p "Response: #{Wit.text_query("turn on the lights in the kitchen", access_token)}"
p "Response: #{Wit.voice_query_auto(access_token)}"
Wit.close
```

See example files for further information.

## Credentials

Thanks to [Justin Workman](http://github.com/xtagon) for releasing a first version in October 2013. We really appreciate!
