extends Node2D

var conversation_history: Array = []

func _ready():
	%Api_access.connectToHost()

func _on_api_access_connection_success():
	$%SENDBUTTON.disabled = false

func _on_sendbutton_pressed():
	if not %RESPONSE.text.is_empty():
		%RESPONSE.text += "\n\n"
	
	var user_message: String = %MESSAGE.text
	if user_message.is_empty():
		return
		
	%RESPONSE.text += "You: " + user_message + "\n"
	
	conversation_history.append({
		"role": "user",
		"content": user_message
	})
	
	var path: String = "/api/chat"
	var messageDict: Dictionary = {
		"model": "MINIKERFUS",
		"messages": conversation_history 
	}
	
	%MESSAGE.text = ""
	
	%Api_access.sendPostRequest(messageDict, path)

var current_assistant_response: String = ""

func _on_api_access_chunk_received(chunk):
	var chunkDict: Dictionary = JSON.parse_string(chunk)
	
	if chunkDict.has("message") and chunkDict["message"].has("content"):
		var text_piece = chunkDict["message"]["content"]
		current_assistant_response += text_piece
		%RESPONSE.text += text_piece
		
	if chunkDict.get("done", false):
		conversation_history.append({
			"role": "assistant",
			"content": current_assistant_response
		})
		current_assistant_response = ""
