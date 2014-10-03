# Wit Ruby SDK [![Gem Version](https://badge.fury.io/rb/wit.svg)](http://badge.fury.io/rb/wit)

This is the Ruby SDK for [Wit.AI](http://wit.ai).

## Prerequisites

This package requires:

* libsox (with -dev files on Debian/Ubuntu, `brew install sox` on OS X)
* libcurl (with -dev files on Debin/Ubuntu, `brew install curl` on OS X)
* a recent Ruby (>= 2.0.0) - install it via [RVM](http://rvm.io) e.g. `rvm install 2.1.3` with [RubyGems](http://rubygems.org)

## Installation instructions

### From RubyGems

```bash
gem install wit
```

### From sources

Run the following command into the main directory (where the `wit.gemspec` is located):

```bash
gem build wit.gemspec
gem install wit-*.gem
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
