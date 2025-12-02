extends Node2D



func _ready():
	%Api_access.connectToHost()

func _on_api_access_connection_success():
	$%SENDBUTTON.disabled = false


func _on_sendbutton_pressed():
	var message : String = %MESSAGE.text
	if message.is_empty():
		return
	var path: String = "/api/generate"
	var messageDict: Dictionary = {
		"model" : "minik",
		"prompt" : message
	}
	%Api_access.sendPostRequest(messageDict, path)


func _on_api_access_chunk_received(chunk):
	var chunkDict : Dictionary = JSON.parse_string(chunk)
	%RESPONSE.text += chunkDict["response"]
	
