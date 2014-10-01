require 'wit'

def handle_response(response)
	p "Response: #{response}"
end

access_token = 'ACCESS_TOKEN'

Wit.init
Wit.voice_query_start(access_token)
sleep(2)
Wit.voice_query_stop_async(Proc.new {|response| p "Response: #{response}"})
sleep(5)
Wit.voice_query_start(access_token)
sleep(2)
Wit.voice_query_stop_async(:handle_response)
sleep(5)
Wit.close
