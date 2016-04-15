require 'wit'

# Quickstart example
# See https://wit.ai/l5t/Quickstart

access_token = 'YOUR_ACCESS_TOKEN'

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

session_id = 'my-user-id-42'
client.run_actions session_id, 'weather in London', {}
