require 'wit'

if ARGV.length == 0
  puts("usage: #{$0} <wit-access-token>")
  exit 1
end

access_token = ARGV[0]
ARGV.shift

# Joke example
# See https://wit.ai/aforaleka/wit-example-joke-bot/

def first_entity_value(entities, entity)
  return nil unless entities.has_key? entity
  val = entities[entity][0]['value']
  return nil if val.nil?
  return val.is_a?(Hash) ? val['value'] : val
end

$all_jokes = {
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

def handle_message(response)
  entities = response['entities']
  get_joke = first_entity_value(entities, 'getJoke')
  greetings = first_entity_value(entities, 'greetings')
  category = first_entity_value(entities, 'category')
  sentiment = first_entity_value(entities, 'sentiment')

  case
  when get_joke
    return $all_jokes[category || 'default'].sample
  when sentiment
    return sentiment == 'positive' ? 'Glad you liked it.' : 'Hmm.'
  when greetings
    return 'Hey this is joke bot :)'
  else
    return 'I can tell jokes! Say "tell me a joke about tech"!'
  end
end

client = Wit.new(access_token: access_token)
client.interactive(method(:handle_message))
