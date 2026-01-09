extends HTTPRequest

const URL:String = "https://kapsvdclsdpdqdwokhwt.supabase.co/rest/v1/FlowerMessages"
const ANON_KEY:String = "sb_publishable_lLGOjxGS6XXFsnYfw_z8MQ_UIDaqOYt"
const REQUEST_HEADERS = [
	"Content-Type: application/json",
	"apikey: " + ANON_KEY, 
	"Authorization: Bearer " + ANON_KEY
	]

func _ready():
	accept_gzip = false
	request_completed.connect(_on_request_completed)
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())

	
func send_message(message:String, x:int, y:int, flower_type:int):
	var body = JSON.stringify({"message":message, "x":x, "y":y,"flower_type":flower_type})
	request(URL,REQUEST_HEADERS,HTTPClient.METHOD_POST, body)
	
func get_flower(x:int, y:int):
	var query = "?x=eq.%d&y=eq.%d" % [x,y]
	var NEW_URL = URL + query
	var code = request(NEW_URL,REQUEST_HEADERS,HTTPClient.METHOD_GET)
	if code != OK:
		print("Error getting this flower")
		return []
	var result = await request_completed
	var responseCode = result[1]
	if responseCode != 200:
		print("Couldn't retrieve flower information from db")
		return[]
	else:
		return JSON.parse_string(result[3].get_string_from_utf8())
	
func get_flowers():
	var code = request(URL,REQUEST_HEADERS,HTTPClient.METHOD_GET)
	if code != OK:
		print ("Couldn't retrieve flower information from db")
		return []
	var result = await request_completed
	var responseCode = result[1]
	
	if responseCode != 200:
		print("Couldn't retrieve flower information from db")
		return[]
	else: 
		return JSON.parse_string(result[3].get_string_from_utf8())
	
	
