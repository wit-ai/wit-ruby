require 'wit'

# Joke example
# See https://wit.ai/patapizza/example-joke

access_token = 'YOUR_ACCESS_TOKEN'

def first_entity_value(entities, entity)
  return nil unless entities.has_key? entity
  val = entities[entity][0]['value']
  return nil if val.nil?
  return val.is_a?(Hash) ? val['value'] : val
end

all_jokes = {
  'chuck' => [
    'Chuck Norris counted to infinity - twice.',
    'Death once had a near-Chuck Norris experience.',
  ],
  'tech' => [
    'Did you hear about the two antennas that got married? The ceremony was long and boring, but the reception was great!',
    'Why do geeks mistake Halloween and Christmas? Because Oct 31 === Dec 25.',
  ],
  'default' => [
    'Why was the Math book sad? Because it had so many problems.',
  ],
}

actions = {
  :say => -> (session_id, context, msg) {
    p msg
  },
  :merge => -> (session_id, context, entities, msg) {
    context.delete 'joke'
    context.delete 'ack'
    category = first_entity_value entities, 'category'
    context['category'] = category unless category.nil?
    sentiment = first_entity_value entities, 'sentiment'
    context['ack'] = sentiment == 'positive' ? 'Glad you liked it.' : 'Hmm.' unless sentiment.nil?
    return context
  },
  :error => -> (session_id, context, error) {
    p error.message
  },
  :'select-joke' => -> (session_id, context) {
    context['joke'] = all_jokes[context['cat'] || 'default'].sample
    return context
  },
}
client = Wit.new access_token, actions

session_id = 'my-user-id-42'
client.run_actions session_id, 'tell me a joke about tech', {}
