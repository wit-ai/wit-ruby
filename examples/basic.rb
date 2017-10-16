require 'wit'

if ARGV.length == 0
  puts("usage: #{$0} <wit-access-token>")
  exit 1
end

access_token = ARGV[0]
ARGV.shift

actions = {
  send: -> (request, response) {
    puts("sending... #{response['text']}")
  },
}

client = Wit.new(access_token: access_token, actions: actions)
client.interactive
