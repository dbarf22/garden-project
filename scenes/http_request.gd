extends HTTPRequest

const URL:String = "https://kapsvdclsdpdqdwokhwt.supabase.co/rest/v1/FlowerMessages"
const ANON_KEY:String = "sb_publishable_lLGOjxGS6XXFsnYfw_z8MQ_UIDaqOYt"
const REQUEST_HEADERS = [
	"Content-Type: application/json",
	"apikey: " + ANON_KEY, 
	"Authorization: Bearer " + ANON_KEY
	]

func _ready():
	request_completed.connect(_on_request_completed)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	print(response_code)
	
func send_message(message:String, x:int, y:int, flower_type:int):
	var body = JSON.stringify({"message":message, "x":x,"y":y,"flower_type":flower_type})
	request(URL,REQUEST_HEADERS,HTTPClient.METHOD_POST, body)
	
