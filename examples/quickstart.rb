require 'wit'

# Quickstart example
# See https://wit.ai/l5t/Quickstart

access_token = ARGV.shift
unless access_token
  puts 'usage: ruby examples/quickstart.rb <access-token>'
  exit
end

def first_entity_value(entities, entity)
  return nil unless entities.has_key? entity
  val = entities[entity][0]['value']
  return nil if val.nil?
  return val.is_a?(Hash) ? val['value'] : val
end

actions = {
  :say => -> (session_id, context, msg) {
    p msg
  },
  :merge => -> (session_id, context, entities, msg) {
    loc = first_entity_value entities, 'location'
    context['loc'] = loc unless loc.nil?
    return context
  },
  :error => -> (session_id, context, error) {
    p error.message
  },
  :'fetch-weather' => -> (session_id, context) {
    context['forecast'] = 'sunny'
    return context
  },
}
client = Wit.new access_token, actions
client.interactive
