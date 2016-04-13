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
  :say => -> (session_id, msg) {
    p msg
  },
  :merge => -> (context, entities) {
    new_context = context.clone
    loc = first_entity_value entities, 'location'
    new_context['loc'] = loc unless loc.nil?
    return new_context
  },
  :error => -> (session_id, msg) {
    p 'Oops I don\'t know what to do.'
  },
  :'fetch-weather' => -> (context) {
    new_context = context.clone
    new_context['forecast'] = 'sunny'
    return new_context
  },
}
client = Wit.new access_token, actions

session_id = 'my-user-id-42'
client.run_actions session_id, 'weather in London', {}
