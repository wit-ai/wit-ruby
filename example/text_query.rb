require 'wit'

access_token = 'ACCESS_TOKEN'

Wit.init
response = Wit.text_query('turn on the lights in the kitchen', access_token)
p "Response: #{response}"
Wit.close
