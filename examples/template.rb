require 'wit'

access_token = 'YOUR_ACCESS_TOKEN'

actions = {
  :say => -> (session_id, context, msg) {
    p msg
  },
  :merge => -> (session_id, context, entities, msg) {
    return context
  },
  :error => -> (session_id, context, error) {
    p error.message
  },
}
client = Wit.new access_token, actions

session_id = 'my-user-id-42'
client.run_actions session_id, 'your message', {}
