# Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.

require 'wit'

if ARGV.length == 0
  puts("usage: #{$0} <wit-access-token>")
  exit 1
end

access_token = ARGV[0]
ARGV.shift

client = Wit.new(access_token: access_token)
client.interactive
