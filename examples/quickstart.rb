require 'wit'

if ARGV.length == 0
  puts("usage: #{$0} <wit-access-token>")
  exit 1
end

access_token = ARGV[0]
ARGV.shift

# Quickstart example
# See https://wit.ai/ar7hur/Quickstart

def first_entity_value(entities, entity)
  return nil unless entities.has_key? entity
  val = entities[entity][0]['value']
  return nil if val.nil?
  return val.is_a?(Hash) ? val['value'] : val
end

actions = {
  send: -> (request, response) {
    puts("sending... #{response['text']}")
  },
  getForecast: -> (request) {
    context = request['context']
    entities = request['entities']

    loc = first_entity_value(entities, 'location')
    if loc
        context['forecast'] = 'sunny'
        context.delete('missingLocation')
    else
        context['missingLocation'] = true
        context.delete('forecast')
    end

    return context
  },
}

client = Wit.new(access_token: access_token, actions: actions)
client.interactive
