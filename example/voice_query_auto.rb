require 'wit'

access_token = 'ACCESS_TOKEN'

Wit.init
response = Wit.voice_query_auto(access_token)
p "Response: #{response}"
Wit.close
