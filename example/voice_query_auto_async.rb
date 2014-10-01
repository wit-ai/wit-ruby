require 'wit'

def handle_response(response)
	p "Response: #{response}"
end

access_token = 'ACCESS_TOKEN'

Wit.init
Wit.voice_query_auto_async(access_token, Proc.new {|response| p "Response: #{response}"})
sleep(5)
Wit.voice_query_auto_async(access_token, :handle_response)
sleep(5)
Wit.close
