require 'wit'

def handle_response(response)
	p "Response: #{response}"
end

access_token = 'ACCESS_TOKEN'

Wit.init
Wit.text_query_async('turn on the lights in the kitchen', access_token, Proc.new {|response| p "Response: #{response}"})
sleep(5)
Wit.text_query_async('turn on the lights in the kitchen', access_token, :handle_response)
sleep(5)
Wit.close
