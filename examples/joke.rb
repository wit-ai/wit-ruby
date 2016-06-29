require 'wit'

if ARGV.length == 0
  puts("usage: #{$0} <wit-access-token>")
  exit 1
end

access_token = ARGV[0]
ARGV.shift

# Joke example
# See https://wit.ai/patapizza/example-joke

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
  send: -> (request, response) {
    puts("sending... #{response['text']}")
  },
  merge: -> (request) {
    context = request['context']
    entities = request['entities']

    context.delete 'joke'
    context.delete 'ack'
    category = first_entity_value(entities, 'category')
    context['category'] = category unless category.nil?
    sentiment = first_entity_value(entities, 'sentiment')
    context['ack'] = sentiment == 'positive' ? 'Glad you liked it.' : 'Hmm.' unless sentiment.nil?
    return context
  },
  :'select-joke' => -> (request) {
    context = request['context']

    context['joke'] = all_jokes[context['category'] || 'default'].sample
    return context
  },
}

client = Wit.new(access_token: access_token, actions: actions)
client.interactive
